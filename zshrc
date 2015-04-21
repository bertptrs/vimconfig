# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export EDITOR=vim

ZSH_THEME="clean"

plugins=(git git-extras composer common-aliases colorize svn tmux ubuntu sudo command-not-found python last-working-dir jsontools bower)

# User configuration
ZSH_TMUX_AUTOSTART=true

export PATH="/vol/share/software/gcc/4.8.2/bin:/vol/share/software/texlive/2013/bin/x86_64-linux:${HOME}/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

source $ZSH/oh-my-zsh.sh

# If I mean interactive, I will tell you.
unalias rm

# Several aliases
gvim='gvim --remote-tab'

if (( $+commands[thefuck] ))
then
	alias fuck='thefuck'
fi
