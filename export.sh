#!/bin/zsh
DIR=$(cd $(dirname "$0"); pwd)
cd $DIR 1>/dev/null
find ~ -maxdepth 1 -name ".vim*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".zsh*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".gdb*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".colorgcc*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".tmux*" -type l -exec rm -v {} \;
rm ~/.config/ranger/rc.conf 2>/dev/null
find ~/.w3m -maxdepth 1 -name "config" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".irssi" -type l -exec rm -v {} \;

ln -s $PWD/vim ~/.vim
ln -s $PWD/vim/.vimrc ~
ln -s $PWD/zsh ~/.zsh
ln -s $PWD/zsh/.zshrc ~
ln -s $PWD/gdb/bundle/gdb-dashboard/.gdbinit ~
ln -s $PWD/gdb/.gdbinit.d ~
ln -s $PWD/.colorgccrc ~
ln -s $PWD/tmux.conf ~
ln -s $PWD/tmux ~/.tmux
ln -s $PWD/tmux/tmux-notifications/bin/* ~/usr/bin
ln -s $PWD/irssi/irssi-notify.sh ~/usr/bin
ln -s $PWD/ranger/rc.conf ~/.config/ranger
ln -s $PWD/w3m ~/.w3m
ln -s $PWD/.inputrc ~
ln -s $PWD/irssi ~/.irssi
ln -s $PWD/mutt ~/.mutt
ln -s $PWD/newsboat ~/.newsboat
ln -s $PWD/mutt ~/.mutt
cd - 1>/dev/null

incrontab -l | grep -q fnotify
if [ $? = 1 ];
then
    ( incrontab -l ; echo "$HOME/.irssi/fnotify IN_MODIFY $HOME/usr/bin/irssi-notify.sh" ) | incrontab -
fi

