#!/bin/sh
DIR=$(cd $(dirname "$0"); pwd)
cd $DIR 1>/dev/null
find ~ -maxdepth 1 -name ".vim*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".zsh*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".tmux*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".gdb*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".colorgcc*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".screen*" -type l -exec rm -v {} \;
find ~ -maxdepth 1 -name ".tmux*" -type l -exec rm -v {} \;

ln -s $PWD/.vim ~
ln -s $PWD/.vim/.vimrc ~
ln -s $PWD/.tmux.conf ~
ln -s $PWD/.zsh ~
ln -s $PWD/.zsh/.zshrc ~
ln -s $PWD/.gdb/.gdbinit ~
ln -s $PWD/.colorgccrc ~
ln -s $PWD/.screenrc ~
ln -s $PWD/.tmux ~
cd - 1>/dev/null
