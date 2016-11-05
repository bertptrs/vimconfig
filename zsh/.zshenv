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
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"/tmux
mkdir -p -m 700 "$TMUX_TMPDIR"
