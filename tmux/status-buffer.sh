#!/usr/bin/env bash
# Double-buffered tmux status, started from tmux.conf: runs the copy for
# this OS. exec keeps our pid, which the script uses as its owner id.

dir=${BASH_SOURCE%/*}
case $OSTYPE in
    darwin*) exec "$dir/status-buffer-macosx.sh" ;;
    *)       exec "$dir/status-buffer-linux.sh" ;;
esac
