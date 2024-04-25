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


# Set up less
export LESS='-x4 -SR'
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
test -d $(dirname $LESSHISTFILE) || mkdir -p $(dirname $LESSHISTFILE)

# Set up editor and vim
if type vim &> /dev/null; then
	export EDITOR=vim
fi

# Set up wine
export WINEPREFIX="$XDG_DATA_HOME/wine"

# Set up Rubygems
if type gem &> /dev/null; then
	path+="$HOME/.gem/bin"
fi

# Set up Weechat alternative directory
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"

# Set up ipython/jupyter
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# Set up GIMP
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp

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

# Add local binaries to path
if [[ -d "$HOME/.local/bin" ]]; then
	path+="$HOME/.local/bin"
fi

# Add cargo binaries to path
if [[ -d "$HOME/.cargo/bin" ]]; then
	path+="$HOME/.cargo/bin"
fi

# Set up GIMP
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp

# Set up OpenSSL
export RANDFILE=$XDG_RUNTIME_DIR/rnd

# Set up various history files
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_repl_history"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql_history"
export PSQL_HISTORY="$XDG_CACHE_HOME/psql_history"
