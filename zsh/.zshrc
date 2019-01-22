# Useful commands
# find . -name "*" -exec grep -n hello /dev/null {} \; # {} is find file
# sed -r 's/.* token_start (.+) token_end .*/\1/'
# sed ':a;N;$!ba;s/\n/ /g' merge two lines to check pattern
# <(cmd) <(cmd) For asynchron piping
# fdupes A/ --recurse: B | grep ^A/ | xargs rm

#zmodload zsh/zprof
export TERM='screen-256color'
bindkey -e

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
        #eval `dircolors -b`
        if xset q &>/dev/null; then
            if which setxkbmap >/dev/null 2>&1; then
                setxkbmap -option ctrl:nocaps
                #setxkbmap -option to enable
            fi
            # i18n
            export GTK_IM_MODULE=ibus
            export XMODIFIERS=@im=ibus
            export QT_IM_MODULE=ibus
        fi
        ;;
    FreeBSD)
        ;;
esac

autoload -Uz copy-earlier-word
zle -N copy-earlier-word

bindkey "^y" copy-earlier-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
#kill the lag
export KEYTIMEOUT=1

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
autoload -U colors && colors
local CREDOR='%{\e[1;31m%}'
local CBROWN='%{\e[0;33m%}'
local BOLDNOC='%{\e[1;0m%}'
local NOCOLOR='%{\e[0m%}'
local MCOLOR='%{\e[0;35m%}'
local CBLUE='%{\e[1;34m%}'
local CGREEN='%{\e[1;32m%}'
local PROMPT_EOL_MARK='$'
setopt prompt_subst

# PS1 and PS2
local ret_code='%(?..[%B%?%b]\n)'
#local date=$CBROWN'(%D{%H:%M:%S})\n'
local ppath=$MCOLOR'%~%b'
local vcs=$CGREEN'${vcs_info_msg_0_}%f%b'
local prompt=$CREDOR'%(!.#.$) %f%b'

if [ -n "$TMUX" ]; then
    export PS1=`print $ret_code$date$CREDOR'['$CBLUE'%n'$CREDOR':'$ppath$CREDOR']'$vcs'\n'$prompt`
else
    export PS1=`print $ret_code$data$CREDOR'['$CBLUE'%n'$CREDOR'@'$CGREEN'%M'$CREDOR':'$ppath$CREDOR']'$vcs'\n'$prompt`
fi
export PS2=`print '%{\e[0;34m%}>'$NOCOLOR`

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
# zsh hooks: precmd, chpwd, preexec, ...
precmd(){
    #Needed for tmux splitting
    vcs_info
}
chpwd() {
    emulate -L zsh
    vcs_info
}

# From Mikachu
function cd-or-accept-line() {
    local success=0;
    args=(${(z)BUFFER});
    if ([ $#args -eq 2 ] && [[ ${(Q)args[1]} == cd* ]]) || ([ $#args -eq 1 ] && [[ ${(Q)args[1]} == cd ]]); then
        ${(Q)args[1]} ${(Q)args[2]} 1>/dev/null 2>/dev/null
        if [ $? -eq 0 ]; then
            zle .kill-buffer;
            zle reset-prompt;
            success=1;
        fi
    fi
    if [ $success -eq 0 ]; then
        zle .$WIDGET;
    fi
};
zle -N accept-line cd-or-accept-line
## Mode at Prompt
#function zle-line-init zle-keymap-select {
#    # Show vim mode on the right
#    RPS1="%{$fg_bold[yellow]%}${${KEYMAP/vicmd/ -- NORMAL --}/(main|viins)/}%f%b"
#    zle reset-prompt
#}
#
#zle -N zle-line-init
#zle -N zle-keymap-select

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
zstyle ':completion:*:*:cd:*' local-directories
# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi;

# This sets the case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

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
bindkey '^[[D' backward-char
bindkey '^[[A' up-line-or-search
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

# Sourcing part
export PATH=~/usr/bin:~/.gem/ruby/2.3.0/bin:~/.local/bin:$PATH
export LD_LIBRARY_PATH=~/usr/lib:$LD_LIBRARY_PATH

export ANDROID_NDK_ROOT=$HOME'/workspace/android/android-ndk-r16b'
export ANDROID_NDK_HOME=$HOME'/workspace/android/android-ndk-r16b'
export ANDROID_HOME=$HOME'/usr/adt-bundle-linux-x86_64-20131030/sdk'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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

bindkey '^[OA' up-line-or-search
bindkey '^[OB' down-line-or-search

# FZF
export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --exclude .git"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -d 1 --type d --color=always --exclude .git --follow"

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1" --color=always
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1" --color=always
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF marks
source $HOME/.zsh/plugins/fzf-marks/init.zsh

#ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8, bold'
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source $HOME/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[builtin]='fg=33'
ZSH_HIGHLIGHT_STYLES[command]='fg=33'
source $HOME/.zsh/plugins/zsh-syntaz-highlighting/zsh-syntax-highlighting.zsh

#zprof
