# Create XDG basedir settings if not set
if [ -z $XDG_CONFIG_HOME ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z $XDG_CACHE_HOME ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z $XDG_DATA_HOME ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi

# Move the remaining zsh installation
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Some systems do not set XDG_RUNTIME_DIR, create an alternative.
if [ -z $XDG_RUNTIME_DIR ]; then
	if [ -n "$TMPDIR" ]; then
		XDG_RUNTIME_DIR="$TMPDIR/$USERNAME"
	else
		XDG_RUNTIME_DIR="/tmp/$USERNAME"
	fi

	mkdir -p "$XDG_RUNTIME_DIR" -m 700
	export XDG_RUNTIME_DIR
fi

# Make gnome-keyring available
if [ -n "$DESKTOP_SESSION" ] && hash gnome-keyring-daemon &> /dev/null; then
	eval $(gnome-keyring-daemon --start)
	export SSH_AUTH_SOCK
fi

# Set up less
export LESS='-x4 -SR'
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
test -d $(dirname $LESSHISTFILE) || mkdir -p $(dirname $LESSHISTFILE)

# Set up editor and vim
if hash vim &> /dev/null; then
	export EDITOR=vim
fi

# Set up compoer
export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
	path+="$COMPOSER_HOME/vendor/bin"
fi

# Set up wine
export WINEPREFIX="$XDG_DATA_HOME/wine"

# Setup tmux
test -f "$XDG_CONFIG_HOME/tmux/tmux.conf" && alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

# Set up Rubygems
if hash gem &> /dev/null; then
	export GEMRC="$XDG_CONFIG_HOME/gem/gemrc"

	#TODO: move this to XDG_DATA_HOME
	export GEM_HOME=$(ruby -e 'puts Gem.user_dir' 2>/dev/null)

	path+="$GEM_HOME/bin"
fi

# Set up Weechat alternative directory
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"

# Set up ipython/jupyter
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# Set up GIMP
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp

# Set up atom
export ATOM_HOME="$XDG_DATA_HOME"/atom

# Set up mplayer
export MPLAYER_HOME="$XDG_CONFIG_HOME"/mplayer

# Set up npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
if [[ -d "$XDG_DATA_HOME/npm/bin" ]]; then
	path+="$XDG_DATA_HOME/npm/bin"
fi

# Set up Vagrant
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"

# Set up sqlite3
test -f "$XDG_CONFIG_HOME/sqlite3/sqliterc" && alias sqlite3="sqlite3 -init \"$XDG_CONFIG_HOME/sqlite3/sqliterc\""

# Set up cargo
export CARGO_HOME="$XDG_CACHE_HOME/cargo"

# Add local binaries to path
if [[ -d "$HOME/.local/bin" ]]; then
	path+="$HOME/.local/bin"
fi

# Set up GIMP
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp

# Set up OpenSSL
export RANDFILE=$XDG_RUNTIME_DIR/rnd
