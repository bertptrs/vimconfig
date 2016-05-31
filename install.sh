#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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
		echo "Installing configuration files for $COMMAND…"
		stow -t $HOME $PACKAGE
	fi
}

if ! commandAvailable stow; then
	echo "Error: stow not available. Skipping installation." >&2
	exit 1
fi

cd $DIR && echo "Current working directory is ${DIR}"

echo -n "Downloading dependencies... "

git submodule init &> /dev/null && git submodule update &> /dev/null \
	|| $(echo "Failed."; echo "Submodule installation failed."; exit 3)

echo "done."



installIfAvailable vim
installIfAvailable zsh
installIfAvailable sqlite3 sqlite

# Install all XDG compatible packages
echo "Installing remaining packages…"
stow -t $HOME pacman git

echo "Installation finished."
