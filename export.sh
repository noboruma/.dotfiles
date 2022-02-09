#!/bin/zsh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CURDIR=$(cd $(dirname "$0"); pwd)

cd $CURDIR 1>/dev/null
find ~ -maxdepth 1 -name ".vim*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".zsh*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".gdb*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".tmux*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".w3m*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".irssi" -type l -exec rm -v {} \;

find ~/usr/bin -maxdepth 1 -name ".irssi-notify.sh" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".inputrc" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".mutt*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".newsboat*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".irbrc" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".gitconfig" -type l -exec rm -v {} \;

find $XDG_CONFIG_HOME -maxdepth 1 -name "ranger" -type l -exec rm -v {} \;
find $XDG_CONFIG_HOME -maxdepth 1 -name "qutebrowser" -type l -exec rm -v {} \;
find $XDG_CONFIG_HOME -maxdepth 1 -name "nvim" -type l -exec rm -v {} \;
find $XDG_CONFIG_HOME -maxdepth 1 -name "vifm" -type l -exec rm -v {} \;

ln -s $CURDIR/vim ~/.vim
ln -s $CURDIR/vim/vimrc ~/.vimrc
ln -s $CURDIR/zsh ~/.zsh
ln -s $CURDIR/zsh/zshrc ~/.zshrc
ln -s $CURDIR/gdb/bundle/gdb-dashboard/.gdbinit ~
ln -s $CURDIR/gdb/gdbinit.d ~/.gdbinit.d
ln -s $CURDIR/tmux/tmux.conf ~/.tmux.conf
ln -s $CURDIR/tmux ~/.tmux
ln -s $CURDIR/irssi/irssi-notify.sh ~/usr/bin
ln -s $CURDIR/ranger $XDG_CONFIG_HOME/ranger
ln -s $CURDIR/w3m ~/.w3m
ln -s $CURDIR/git ~/.gitconf
ln -s $CURDIR/etc/inputrc ~/.inputrc
ln -s $CURDIR/irssi ~/.irssi
ln -s $CURDIR/newsboat ~/.newsboat
ln -s $CURDIR/mutt ~/.mutt
ln -s $CURDIR/ruby/irbrc ~/.irbrc
ln -s $CURDIR/nvim $XDG_CONFIG_HOME/nvim
ln -s $CURDIR/etc/surfraw.conf $XDG_CONFIG_HOME/.surfraw.conf
ln -s $CURDIR/git/gitconfig ~/.gitconfig
ln -s $CURDIR/ssh/rc ~/.ssh/rc

cd - 1>/dev/null

if [ -x "$(command -v incrontab)" ]; then
    incrontab -l | grep -q fnotify
    if [ $? = 1 ];
    then
        ( incrontab -l ; echo "$HOME/.irssi/fnotify IN_MODIFY $HOME/usr/bin/irssi-notify.sh" ) | incrontab -
    fi
else
    echo "incontrab not installed: irssi notification disabled"
fi

git config --global core.hooksPath $HOME/.gitconf/hooks
git config --global alias.conflicts "diff --name-only --diff-filter=U"

# Docker related setup
mkdir $HOME/.docker 2>/dev/null
touch $HOME/.docker/sh_history
touch $HOME/.docker/ash_history
touch $HOME/.docker/bash_history
touch $HOME/.docker/zsh_history
