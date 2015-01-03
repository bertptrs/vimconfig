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

echo "Installing .vimrc"
ln -s $HOME/.vim/vimrc $HOME/.vimrc

echo -n "Downloading dependencies..."
cd $HOME/.vim

git submodule init
git submodule update

echo " Done"

echo
echo "Installation finished."
