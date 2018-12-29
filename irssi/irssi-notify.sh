#!/bin/sh
$HOME/usr/bin/tmux-notify "talk on `cat /home/zackel/.irssi/fnotify | tail -n1 | cut -d' ' -f2`"
