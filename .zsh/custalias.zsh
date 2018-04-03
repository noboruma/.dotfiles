##################################################################
# Aliases

# Set up auto extension stuff
alias -s net=$BROWSER
# alias -s torrent="qbittorrent"
alias -s gz=tar -xzvf
#alias -s bz2=tar -xjvf
alias -s PKGBUILD=$EDITOR
alias xterm='xterm -fg white -bg black'

# Normal aliases
case `uname` in
  Darwin)
alias ls='ls -GFh'
  ;;
  Linux)
alias ls='ls --color=auto -Fh'
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac
#alias lsd='ls -ld *(-/DN)'
#alias lsa='ls -ld .*'
alias f='find -type f | xargs grep'
alias c="clear"
alias ..='cd ..'
#alias ppp-on=' /usr/sbin/ppp-on'
#alias ppp-off=' /usr/sbin/ppp-off'
alias hist="grep '$1' ~/.zsh_history"
#alias irssi="irssi -c irc.freenode.net -n yyz"
alias mem="free -m"

# command L equivalent to command |less
alias -g L='|less'

# command S equivalent to command &> /dev/null &
alias -g N='&> /dev/null &'

alias sshfs='sshfs -C -o reconnect -o workaround=all'

alias sifconfig='sudo ifconfig'
alias siptables='sudo iptables'
alias sai='sudo aptitude install'
alias aS='aptitude search'
alias saR='sudo aptitude remove'
alias sau='sudo aptitude update'
alias saup='sudo aptitude update && sudo aptitude safe-upgrade'
alias e=$IDE
alias v=$EDITOR
alias sv='sudo $EDITOR'
alias com='git commit -am'
alias push='git push'
alias pull='git pull'
alias ocaml='rlwrap ocaml'

alias smount="sudo mount"
alias sumount="sudo umount"
alias srcconf="sudo rcconf"
alias pwdb="pwman3"
alias sshut="sudo shutdown -h 0"
alias shibern="sudo pm-hibernate"
alias sreboot="sudo reboot"

alias arduino="arduino-asm&"
alias m='mw gmake -j4'
alias mc='mw gmake -j4 check'

alias ll="ls -al"
alias du="du -h"
alias df="df -h"

alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias indrc="vim ~/.indexer_files"

alias er="gvim --servername GVIM --remote"
alias ers="gvim --servername GVIM"
alias edebug="gvim --cmd 'let debug=1'"
alias vdebug="vim --cmd 'let debug=1'"
alias vdev="vim --cmd 'let indexing=1' --servername VIM"
alias vimdev="vim --cmd 'let indexing=1' --servername VIM"

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'

if type "colordiff" > /dev/null; then
  alias diff="colordiff"
fi
alias p4v="p4v&"
alias p4lsdefault="p4 opened | grep default"
alias p4lschanges="p4 changes -s pending -c \`p4 client -o | sed -n 's/^Client:\(.*\)$/\1/p'\`"
alias lsp4sanbox="p4lsdefault; p4lschanges"
function p4listfiles () { p4 opened -c ${@:$#} | sed 's/.*\/matlab/\./g' | sed 's/#[0-9]\+//g' | GREP_COLOR='01;36' grep --color=always 'move\|$' | GREP_COLOR='01;32' grep --color=always 'add\|$' | GREP_COLOR='01;32' grep --color=always 'edit\|$' | GREP_COLOR='01;31' grep --color=always '^.*delete.*$\|$' | GREP_COLOR='01;31' grep --color=always 'delete.*\|$'}
alias lsp4change="p4listfiles"
function p4discardshevle () { p4 shelve -d -c $1; p4 shelve -c $1 }
alias p4shelve="p4discardshevle"
alias cdp4root="cd \`p4 client -o | sed -n 's/^Root:\(.*\)$/\1/p'\`"
alias diffp4="P4DIFF=colordiff p4 diff"
alias vdiffp4="P4DIFF=vimdiff p4 diff"
alias p4delshelve="p4 shelve -d -c"
alias p4addshelve="p4 shelve -c"
function p4reviewNsubmit() { p4 change -u $1; p4 submit -c $1 }
alias p4submit="p4reviewNsubmit"
