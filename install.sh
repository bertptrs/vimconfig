#!/bin/bash

if [ -f $HOME/.vimrc ]
then
	echo "Already have a local vimrc, abort."
	exit 1
fi

if [ ! -f $HOME/.vim/vimrc ]
then
	echo "Vimconfig rc not found, abort."
	exit 2
fi


echo -n "Downloading dependencies... "
cd $HOME/.vim

git submodule init &> /dev/null && git submodule update &> /dev/null \
	|| $(echo "Failed."; echo "Submodule installation failed."; exit 3)

echo "Done."

echo "Installing .vimrc"
ln -s $HOME/.vim/vimrc $HOME/.vimrc

echo
echo "Installation finished."
