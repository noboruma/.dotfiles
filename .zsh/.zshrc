# Useful commands
# find . -name "*" -exec grep -n hello /dev/null {} \; # {} is find file
# sed -r 's/.* token_start (.+) token_end .*/\1/'
# sed ':a;N;$!ba;s/\n/ /g' merge two lines to check pattern
# <(cmd) <(cmd) For asynchron piping
# fdupes A/ --recurse: B | grep ^A/ | xargs rm

#export TERM='screen-256color'

# Root allow X?
# xhost + > /dev/null 2> /dev/null || true

# Let's reset caps lock (setxkbmap -option to re-enable)
# setxkbmap -option ctrl:nocaps
# Best layout ever:
# setxkbmap -layout us -variant intl

###########################################################
# Options for Zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
case `uname` in
  Darwin)
  ;;
  Linux)
eval `dircolors -b`
setxkbmap -option ctrl:nocaps
#setxkbmap -option to enable
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac

#set -o vi
#bindkey -v
#bindkey -M vicmd 'u' undo
#bindkey -M vicmd '^r' redo
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
#kill the lag
#export KEYTIMEOUT=1

autoload -Uz compinit
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
#setopt cdablevars
#setopt ignoreeof
setopt interactivecomments
#setopt nobanghist
setopt noclobber # Use >! to override file
setopt SH_WORD_SPLIT
setopt nohup
setopt transientrprompt
#setopt PRINT_EXIT_VALUE
#history
setopt histignorespace
setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt CORRECT

#print colors
local CREDOR='%{\e[1;31m%}'
local CBROWN='%{\e[0;33m%}'
local BOLDNOC='%{\e[1;0m%}'
local NOCOLOR='%{\e[0m%}'
local MCOLOR='%{\e[0;35m%}'
local CBLUE='%{\e[1;34m%}'
local CGREEN='%{\e[1;32m%}'

# PS1 and PS2
export PS1="$(print $CBROWN'(%D{%L:%M:%S %p})\n'\
$CREDOR'['$CBLUE'%n'$CREDOR'@'$CGREEN'%M'$CREDOR']'$MCOLOR%d%b'\n'\
$CREDOR'$ '%f%b)"
export PS2="$(print '%{\e[0;34m%}>'$NOCOLOR)"

#export RPROMPT='[%D{%L:%M:%S %p}]'
#TMOUT=0
#TRAPALRM() {
#   zle reset-prompt
#}
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
  vcs_info
}
# Mode at Prompt
function zle-line-init zle-keymap-select {
    # Show exit code on the right if it was != 0
    RPS1="%(?..[%B%?%b])%{%F{red}%}${vcs_info_msg_0_}%{$fg_bold[yellow]%}${${KEYMAP/vicmd/ -- NORMAL --}/(main|viins)/}%f%b"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Vars used later on by Zsh
export EDITOR="vim"
export VISUAL="vim"
export GIT_EDITOR="$EDITOR"
export IDE="gvim"
export BROWSER="w3m"
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export PAGER="less"

##################################################################
# Stuff to make life easier

# allow approximate
#zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:cd:*' tag-order local-directories
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -U colors && colors
compinit

# This sets the case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion:*' menu select
setopt menu_complete

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

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
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word

autoload -U select-word-style
select-word-style bash

source ~/.zsh/custalias.zsh

set inc

# Enable v inside command
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# i18n
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# Sourcing part
export PATH=~/usr/bin:$PATH
export PATH=/usr/local/cuda-7.5/bin:$PATH
export LD_LIBRARY_PATH=~/usr/lib:$LD_LIBRARY_PATH

export ANDROID_NDK_ROOT=$HOME'/workspace/android/android-ndk-r16b'
export ANDROID_NDK_HOME=$HOME'/workspace/android/android-ndk-r16b'
export ANDROID_HOME=$HOME'/usr/adt-bundle-linux-x86_64-20131030/sdk'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export P4CONFIG=.perforce

export NPM_PACKAGES="${HOME}/usr/npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"
#source ~/usr/emsdk-portable/emsdk_env.sh
#source ~/.sdkman/bin/sdkman-init.sh

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

# Plugin part
export ZBEEP=''
# History
setopt HIST_FIND_NO_DUPS
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# FZF
export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --exclude .git"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --color=always --exclude .git --follow"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF marks
source $HOME/.zsh/plugins/fzf-marks/init.zsh

# zsh-bd
source $HOME/.zsh/plugins/bd/bd.zsh

echo 'running on '$TTY
