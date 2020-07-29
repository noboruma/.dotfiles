#!/bin/sh
$HOME/.tmux/tmux-notifications/bin/tmux-notify "talk on `cat $HOME/.irssi/fnotify | tail -n1 | cut -d' ' -f2`"
