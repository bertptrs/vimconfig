#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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

# Install vim

echo "Installing vim."

confirmAndLink $DIR/vim/vimrc $HOME/.vimrc
confirmAndLink $DIR/vim $HOME/.vim

which zsh
if which zsh
then
	echo "Installing zsh"
	
	if [ ! -e $HOME/.oh-my-zsh ]
	then
		curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
		rm $HOME/.zshrc
	else
		confirmAndLink $DIR/zshrc $HOME/.zshrc
	fi
	
	echo "Installation finished."
fi
