#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

commandAvailable() {
	command -v $1 >/dev/null
}

installIfAvailable() {
	if [ $# -lt 1 ]; then
		echo "Usage: $0 command_required [package_name]" >&2
		return 1
	fi

	COMMAND=$1
	if [ $# -eq 2 ]; then
		PACKAGE=$2
	else
		PACKAGE=$COMMAND
	fi

	if commandAvailable $COMMAND; then
		echo "Installing configuration files for $PACKAGE…"
		stow -t $HOME $PACKAGE
	fi
}

if ! commandAvailable stow; then
	echo "Error: stow not available. Skipping installation." >&2
	exit 1
fi

echo -n "Downloading dependencies... "

git submodule update --init &> /dev/null \
	|| (echo "Failed."; echo "Submodule installation failed."; exit 3)

echo "done."

if commandAvailable vim; then
	echo "Creating vim directories"
	mkdir -p $HOME/.cache/vim/{backup,swap,undo}
fi

installIfAvailable vim
installIfAvailable zsh
installIfAvailable sqlite3 sqlite
installIfAvailable tmux
installIfAvailable systemctl systemd
installIfAvailable pacman
installIfAvailable git
installIfAvailable latexmk


if commandAvailable weechat; then
	echo "Setting up weechat settings…"
	./weechat.sh
fi

if commandAvailable gsettings; then
	echo "Installing gsettings preferences…"
	./gsettings.sh
fi

echo "Installation finished."
