# zshrc aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias grep='grep --color=auto'
alias gvim='gvim --remote-tab'

if (( $+commands[thefuck] ))
then
	alias fuck='$(thefuck $(fc -ln -1))'
fi

export EDITOR=$(which vim)

# Initialize the prompt
autoload -U promptinit
promptinit
prompt bart

# No dupes in history
setopt HIST_IGNORE_DUPS

# Shared history between sessions
setopt inc_append_history
setopt share_history

# Setup the CNF hook
if [[ -s /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
	source /usr/share/doc/pkgfile/command-not-found.zsh
elif [[ -s /etc/zsh_command_not_found ]]; then
	source /etc/zsh_command_not_found
fi

# Add Composer binaries
if [ -d "$HOME/.composer" ]; then
	path+=("$HOME/.composer/vendor/bin")
fi

# No matches found for "*"
unsetopt nomatch

# History search
autoload -U history-search-end
bindkey -v

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N history-incremental-search-backward-end history-search-end

bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end
bindkey '^R' history-incremental-search-backward-end

# Home and end keys working
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# Transfer.sh plugin
transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }; alias transfer=transfer

# The following lines were added by compinstall

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
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify
bindkey -v
# End of lines configured by zsh-newuser-install
