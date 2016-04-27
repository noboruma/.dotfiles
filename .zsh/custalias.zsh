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
alias ls='ls --color=auto -Fh'
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

alias ifconfig='sudo ifconfig'
alias iptables='sudo iptables'
alias ai='sudo aptitude install'
alias aS='sudo aptitude search'
alias aR='sudo aptitude remove'
alias au='sudo aptitude update'
alias aup='sudo aptitude update && sudo aptitude safe-upgrade'
alias e=$IDE
alias v=$EDITOR
alias sv='sudo $EDITOR'
alias com='git commit -am'
alias push='git push'
alias pull='git pull'
alias ocaml='rlwrap ocaml'

alias mount="sudo mount"
alias umount="sudo umount"
alias rcconf="sudo rcconf"
alias pwdb="pwman3"
alias shut="sudo shutdown -h 0"
alias hibern="sudo pm-hibernate"
alias reboot="sudo reboot"

alias arduino="arduino-asm&"
alias g++='g++ -std=c++0x'
alias m='make -j2'
alias mc='make -j2 check'

alias ll="ls -al"
alias du="du -h"
alias df="df -h"

alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
