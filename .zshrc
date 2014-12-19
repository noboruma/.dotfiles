# Useful commands
# find . -name "*" -exec grep -n hello /dev/null {} \; # {} is find file
# sed -r 's/.* token_start (.+) token_end .*/\1/'
# sed ':a;N;$!ba;s/\n/ /g' merge two lines to check pattern


# Let's reset caps lock (setxkbmap -option to re-enable)
setxkbmap -option ctrl:nocaps

###########################################################        
# Options for Zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
eval `dircolors -b`

#set -o vi
autoload -U compinit compinit
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdablevars
#setopt ignoreeof
setopt interactivecomments
setopt nobanghist
setopt noclobber
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt nohup

# PS1 and PS2
export PS1="$(print '%{\e[1;31m%}[%{\e[0m%}%{\e[1;34m%}%n%{\e[0m%}%{\e[1;31m%}@%{\e[0m%}%{\e[1;32m%}%M%{\e[0m%}%{\e[1;31m%}]%{\e[0m%}%'):$(print '%{\e[0;35m%}%~%{\e[0m%}$') "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Date at Prompt
RPROMPT='[%D{%L:%M:%S %p}]'
TMOUT=0
TRAPALRM() {
   zle reset-prompt
}

# Vars used later on by Zsh
export EDITOR="vim"
export IDE="gvim -geometry 500x500"
export BROWSER="w3m"
export XTERM="aterm +sb -geometry 80x29 -fg black -bg lightgoldenrodyellow -fn -xos4-terminus-medium-*-normal-*-14-*-*-*-*-*-iso8859-15"

##################################################################
# Stuff to make my life easier

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:cd:*' tag-order local-directories
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[5~' history-search-backward
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

##################################################################
# My aliases

# Set up auto extension stuff
#alias -s html=$BROWSER
#alias -s org=$BROWSER
#alias -s php=$BROWSER
#alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s torrent="qbittorrent"
#alias -s png=feh
#alias -s jpg=feh
#alias -s gif=feg
#alias -s sxw=soffice
#alias -s doc=soffice
#alias -s gz=tar -xzvf
#alias -s bz2=tar -xjvf
#alias -s java=$EDITOR
#alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR

# Normal aliases
alias ls='ls --color=auto -Fh'
#alias lsd='ls -ld *(-/DN)'
#alias lsa='ls -ld .*'
alias f='find -type f |xargs grep'
alias c="clear"
alias gvim='gvim -geom 82x35'
alias ..='cd ..'
#alias nicotine='/home/paul/downloads/nicotine-1.0.8rc1/nicotine'
#alias ppp-on=' /usr/sbin/ppp-on'
#alias ppp-off=' /usr/sbin/ppp-off'
#alias firestarter=' su -c firestarter'
#alias mpg123='mpg123 -o oss'
#alias mpg321='mpg123 -o oss'
#alias vba='/home/paul/downloads/VisualBoyAdvance -f 4'
alias hist="grep '$1' /home/paul/.zsh_history"
#alias irssi="irssi -c irc.freenode.net -n yyz"
#alias mem="free -m"
#alias msn="tmsnc -l hutchy@subdimension.com"

# command L equivalent to command |less
alias -g L='|less' 

# command S equivalent to command &> /dev/null &
alias -g N='&> /dev/null &'

alias sshfs='shfs -C -o reconnect -o workaround=all'

alias ifconfig='sudo ifconfig'
alias iptables='sudo iptables'
alias ai='sudo aptitude install'
alias aS='sudo aptitude search'
alias ar='sudo aptitude remove'
alias au='sudo aptitude update'
alias aup='sudo aptitude update && sudo aptitude safe-upgrade'
alias vem='$IDE -nw'
alias e=$IDE
alias v=$EDITOR
alias com='git commit -am'
alias push='git push'
alias pull='git pull'
alias ocaml='rlwrap ocaml'

alias mount="sudo mount"
alias umount="sudo umount"
alias umount="sudo route"
alias umount="sudo iwconfig"
alias find="sudo find"
alias rcconf="sudo rcconf"
alias pwdb="pwman3"
alias shut="sudo shutdown -h 0"
alias reboot="sudo reboot"

alias arduino="arduino-asm&"
alias g++='g++ -std=c++0x'
alias m='make -j2'
alias mc='make -j2 check'
#alias g++='~/usr/colorgcc/colorgcc.pl'
#alias gcc='~/usr/colorgcc/colorgcc.pl'

alias ll="ls -al"
alias du="du -h"
alias df="df -h"
alias x="fg"

set inc

# Root allow X?
xhost + > /dev/null 2> /dev/null || true

# OPAM configuration
. /home/zackel/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
CAML_LD_LIBRARY_PATH=/home/zackel/.opam/4.00.1/lib/stublibs; export CAML_LD_LIBRARY_PATH;
OCAML_TOPLEVEL_PATH=/home/zackel/.opam/4.00.1/lib/toplevel; export OCAML_TOPLEVEL_PATH;
MANPATH=/home/zackel/.opam/4.00.1/man:; export MANPATH;
export PATH=$PATH:/home/zackel/.opam/4.00.1/bin
#$PATH:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games;

export PATH=~/usr/bin:$PATH

## JAVA
#export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386
#export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.26
#
# vim CTRL-Z helper
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

alias x=dolphin
