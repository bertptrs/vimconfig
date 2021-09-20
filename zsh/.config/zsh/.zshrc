# Check if we want a multiplexer.
#
# We want one if we are either:
# - connected over SSH (for security), or
# - using alacritty, since it doesn't have tabs.
function want_multiplexer() {
	[[ $TERM == "alacritty" ]] || \
		[[ -n $SSH_TTY ]]
}


# If we want a multiplexer and not already in tmux, start tmux.
if [[ -o interactive ]] && want_multiplexer && [[ -z $TMUX ]] && type tmux &> /dev/null; then
	if tmux has-session &> /dev/null; then
		tmux attach
	else
		tmux
	fi
	exit $?
fi

unset -f want_multiplexer

# Check for service-managed keyring
if [[ -z $SSH_AUTH_SOCK ]] && [[ -S $XDG_RUNTIME_DIR/ssh-agent.socket ]]; then
	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

#######################
# Initialize keyboard #
#######################

autoload zkbd
keyfile="$XDG_CONFIG_HOME/zsh/zkbd/${TERM}"
if [[ -f ${keyfile} ]]; then
    source "${keyfile}"
elif [[ -o interactive ]]; then
	echo "Unable to load key data for special keys. Run zkbd to fix."
fi
unset keyfile

################
# Load plugins #
################
plugins=(
	zsh-autosuggestions/zsh-autosuggestions.zsh
	zsh-you-should-use/you-should-use.plugin.zsh
	nix-zsh-completions/nix-zsh-completions.plugin.zsh
	zsh-auto-notify/auto-notify.plugin.zsh
)

for plugin in "${plugins[@]}"; do
	if [[ -f "$ZDOTDIR/plugins/$plugin" ]]; then
		source "$ZDOTDIR/plugins/$plugin"
	fi
done

fpath+=("$ZDOTDIR/plugins/nix-zsh-completions")

# Configure auto-notify
AUTO_NOTIFY_IGNORE+=(
	"gcloud compute ssh"
	"nix run"
	"git"
	"bash"
	"sem debug"
	"git log"
	"journalctl"
	"jekyll serve"
)


## Autosuggest plugin configuration
# Consider autocomplete in completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Enable async suggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# No completions for long commands
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

bindkey -e
# zshrc aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias gvim='gvim --remote-tab'
alias userctl='systemctl --user'
alias :q='exit'
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""
alias makej="make -j$(nproc)"
alias sdc='sudo docker-compose'
alias nrc='nix run -c'
alias gcs='gcloud compute ssh'
alias gscp='gcloud compute scp'
alias gci='gcloud compute instances'

# Not an alias but useful nonetheless.
function pasters() {
	local file=${1:-/dev/stdin}
	curl --data-binary @${file} https://paste.rs
}

# Ensure we can make cheap copies on btrfs
alias cp='cp --reflink=auto'

if (( $+commands[thefuck] ))
then
	alias fuck='$(thefuck $(fc -ln -1))'
fi

eval "$(dircolors)"

# Initialize the prompt
source "${ZDOTDIR:-$HOME}/.zshtheme"

# Setup the CNF hook
if [[ -s /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
	source /usr/share/doc/pkgfile/command-not-found.zsh
elif [[ -s /etc/zsh_command_not_found ]]; then
	source /etc/zsh_command_not_found
fi

# Load up help files
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-svn
autoload -Uz run-help-svk

if [[ "${$(type run-help)#*alias}" != "$(type run-help)" ]]; then
	unalias run-help
fi

alias help=run-help

# Set sensible tab width
tabs -4

# No matches found for "*"
unsetopt nomatch

# History search
autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N history-incremental-search-backward-end history-search-end

[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward
bindkey '^R' history-incremental-search-backward-end

# Load optional plugins if installed on the host system.
find_system_plugin() {
	local plugin=$1
	local plugin_dirs=(
		/usr/share/zsh/plugins
		/usr/share
	)
	local dir

	for dir in "${plugin_dirs[@]}"; do
		if [[ -f "$dir/$plugin/$plugin.zsh" ]]; then
			echo "$dir/$plugin/$plugin.zsh"
			return
		fi
	done

	# Safe placeholder
	echo /dev/null
}


source $(find_system_plugin zsh-syntax-highlighting)

# Home and end keys working
bindkey "${key[Home]}" beginning-of-line
bindkey "${key[End]}" end-of-line

# Transfer.sh plugin
transfer() {
	if [ $# -eq 0 ]; then
		echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
		return 1;
	fi
	tmpfile=$( mktemp -t transferXXX )
	if tty -s; then
		basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
		curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
	else
		curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
	fi
	cat $tmpfile
	echo
	rm -f $tmpfile
}
alias transfer=transfer

##############################
# Autocomplete configuration #
##############################

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/bert/.zshrc'

autoload -Uz compinit
# Register our custom completions
fpath+=("${ZDOTDIR:-$HOME}/completions")
compinit

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end

# Load gcloud completions if they are available
if [[ -f /usr/share/google-cloud-sdk/completion.zsh.inc ]]; then
	source /usr/share/google-cloud-sdk/completion.zsh.inc
fi

# Enable autocorrect, in case I still get it wrong
setopt correct
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [ynae] "

##########################
## History configuration #
##########################

# Shared history between sessions
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_expire_dups_first
setopt extended_history # Record times in history
setopt hist_ignore_all_dups

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Configure alternative histfile location
HISTFILE="$XDG_DATA_HOME/zsh/histfile"
if [ ! -d $(dirname $HISTFILE) ]
then
	mkdir -p $(dirname $HISTFILE)
fi

# Increase history size
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt autocd # Automatically cd to dirs typed
setopt notify

#####################
# Directory history #
#####################

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

######################################
# Application-specific configuration #
######################################

# Make less understand more file types
if (( $+commands[lesspipe] )); then
	eval "$(lesspipe)"
fi

# Use bat as a man pager if it's available
if (( $+commands[bat] )); then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

############################
# Special SSH key handling #
############################

if [[ -f ~/.ssh/id_ed25519 ]]; then
	# gnome-keyring doesn't handle ed25519 keys properly; try setting up an alternative agent.
	export SSH_ENV="$HOME/.ssh/environment"

	start_agent() {
		echo "Initialising new SSH agent..."
		/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
		echo Succeeded
		chmod 600 "${SSH_ENV}"
		. "${SSH_ENV}" > /dev/null
		/usr/bin/ssh-add ~/.ssh/google_compute_engine >/dev/null 2>&1
	}

	if [ -f "${SSH_ENV}" ]; then
		. "${SSH_ENV}" > /dev/null
		kill -0 "$SSH_AGENT_PID" 2>/dev/null || { start_agent; }
	else
		start_agent
	fi
fi
