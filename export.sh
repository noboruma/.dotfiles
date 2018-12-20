#!/bin/sh
DIR=$(cd $(dirname "$0"); pwd)
cd $DIR 1>/dev/null
find ~ -maxdepth 1 -name ".vim*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".zsh*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".gdb*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".colorgcc*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".tmux*" -type l -exec rm -v {} \;
rm ~/.config/ranger/rc.conf 2>/dev/null
find ~/.w3m -maxdepth 1 -name "config" -type l -exec rm -v {} \;

ln -s $PWD/.vim ~
ln -s $PWD/.vim/.vimrc ~
ln -s $PWD/.tmux.conf ~
ln -s $PWD/.zsh ~
ln -s $PWD/.zsh/.zshrc ~
ln -s $PWD/.gdb/bundle/gdb-dashboard/.gdbinit ~
ln -s $PWD/.gdb/.gdbinit.d ~
ln -s $PWD/.colorgccrc ~
ln -s $PWD/.tmux ~
ln -s $PWD/ranger/rc.conf ~/.config/ranger
ln -s $PWD/.w3m/config ~/.w3m/config
ln -s $PWD/.inputrc ~
cd - 1>/dev/null
