#!/bin/sh
DIR=$(cd $(dirname "$0"); pwd)
cd $DIR 1>/dev/null
ln -s $PWD/.vim ~
ln -s $PWD/.vim/.vimrc ~
ln -s $PWD/.tmux.conf ~
ln -s $PWD/.zshrc ~
ln -s $PWD/.gdbinit ~
ln -s $PWD/.colorgccrc ~
ln -s $PWD/.screenrc ~
cd - 1>/dev/null
