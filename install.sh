#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

commandAvailable() {
	command -v $1 >/dev/null
}

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

confirmAndLink() {
	if [ -e $2 ]
	then
		echo "Destination $2 already exists and will be overwritten."
		confirm && rm -rf $2 && ln -s $1 $2
	else
		ln -s $1 $2
	fi
}

cd $DIR && echo "Current working directory is ${DIR}"

echo -n "Downloading dependencies... "

git submodule init &> /dev/null && git submodule update &> /dev/null \
	|| $(echo "Failed."; echo "Submodule installation failed."; exit 3)

echo "done."

if ! commandAvailable stow; then
	echo "Error: stow not available. Skipping installation." >&2;
	exit 1;
fi

# Install vim

if commandAvailable vim
then
	echo "Installing configuration files for vim.";
	stow -t $HOME vim
fi

# Install zsh, if relevant.
if commandAvailable zsh
then
	echo "Installing configuration files for zsh."
	stow -t $HOME zsh
fi

if commandAvailable "sqlite3"
then
	echo "Installing configuration files for sqlite."
	stow -t $HOME sqlite
fi

# Install all XDG compatible packages
echo "Installing remaining packages"
stow -t $HOME pacman git

echo "Installation finished."
