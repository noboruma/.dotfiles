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
alias sai='sudo apt install'
alias aS='aptitude search'
alias saR='sudo apt remove'
alias sau='sudo apt update'
alias saup='sudo aptitude safe-upgrade'
alias e=$IDE
alias v=$EDITOR
alias sv='sudo $EDITOR'
alias gcommit='git commit -am'
alias gpush='git push'
alias gpull='git pull'
#alias ocaml='rlwrap ocaml'

alias smount="sudo mount"
alias sumount="sudo umount"
alias srcconf="sudo rcconf"
alias pwdb="pwman3"
alias sshut="sudo shutdown -h 0"
alias shibern="sudo pm-hibernate"
alias sreboot="sudo reboot"

alias arduino="arduino-asm"
alias m='make -j4'
alias mc='make -j4 check'

alias l='unique_ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ll="ls -haltr"
alias du="du -h"
alias df="df -h"

alias dotfiles="cd ~/.dotfiles"
alias vrc="vim ~/.vimrc"
alias zrc="vim ~/.zshrc"
alias trc="vim ~/.tmux.conf"
alias mrc="vim ~/.mutt/neomuttrc"
alias irc="vim ~/.irssi/config"

alias er="gvim --servername GVIM --remote"
alias ers="gvim --servername GVIM"
alias vdev="vim --servername VIM --remote"
alias vimdev="vim --servername VIM"
alias ff="fzf-fs"

alias ttyw3m="TERM=fbterm w3m"
alias news="newsboat --config-file=$HOME/.newsboat/config --url-file=$HOME/.newsboat/urls"
alias nmutt='neomutt'

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'

if type "colordiff" > /dev/null; then
  alias diff="colordiff"
fi

# Go back (..) n times
cdn () { pushd .; for ((i=1; i<=$1; i++)); do cd ..; done; pwd; }

# Go up until reaching $1, ie: cdu home
cdu () { cd "${PWD%/$1/*}/$1"; }

function vgdb () {
    vim -c ":Termdebug "$1
}

#function mwfindPath () {
#    mw ch findPath -c $1 $2 -f DOT | dot -Tx11
#}

function unique_ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        ranger "$@"
    else
        exit
    fi
}

# default tmux layout
function tnetsession() {
    if [[ -v GMAIL_USERNAME ]]; then
        tmux setenv GMAIL_USERNAME $GMAIL_USERNAME
    fi
    tmux new-session -d -s 'netclients'
    tmux new-window -d -k -t netclients:1 'neomutt'
    tmux new-window -d -k -t netclients:2 'irssi'
    tmux new-window -d -k -t netclients:3 'newsboat --config-file=$HOME/.newsboat/config --url-file=$HOME/.newsboat/urls'
}
