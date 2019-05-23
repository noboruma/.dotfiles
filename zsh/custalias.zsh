##################################################################
# Aliases

# Set up auto extension stuff
alias -s net=$BROWSER
alias -s gz=tar -xzvf
alias -s PKGBUILD=$EDITOR
alias xterm='xterm -fg white -bg black'

# Normal aliases
case `uname` in
    Darwin)
        alias ls='ls -GFh'
        ;;
    Linux)
        alias ls='ls --color=always -Fh'
        ;;
    FreeBSD)
        ;;
esac
alias fe='find -type f | xargs grep'
alias c="clear"
#alias irssi="irssi -c irc.freenode.net -n yyz"
alias mem="free -m"

alias -g V='|vim -'
alias -g N='1> /dev/null'

alias sshfs='sshfs -C -o reconnect -o workaround=all'

alias sifconfig='sudo ifconfig'
alias siptables='sudo iptables'
alias spi='sudo pacman -S'
alias spu='sudo pacman -Syu'
alias sps='pacman -Ss'
alias spr='sudo pacman -Rcns'
# makepkg -sri
alias sai='sudo apt install'
alias aS='aptitude search'
alias saR='sudo apt remove'
alias sau='sudo apt update'
alias saup='sudo aptitude safe-upgrade'
alias v='vim'
alias nv="nvim"
alias sv='sudo vim'
alias snv='sudo nvim'
alias gcommit='git commit -am'
alias gpush='git push'
alias gpull='git pull'
alias gchange='git checkout -'
alias gconflicts='git diff --name-only --diff-filter=U'
alias gup='git submodule update --recursive --remote --init'
alias gls='git ls-tree --name-only HEAD | ls'
alias grep='grep --color'
alias tree='tree -C'

alias smount="sudo mount"
alias sumount="sudo umount"
alias srcconf="sudo rcconf"
alias pwdb="pwman3"
alias sshut="sudo shutdown -h 0"
alias sreboot="sudo reboot"

alias arduino="arduino-asm"
alias m='make -j4'
alias mc='make -j4 check'

function l() {
    tree $1 -shDFCL 1 | grep --color=always -E '\[.*\]|$'
}
alias ll="ls -haltr"
alias du="du -h"
alias df="df -h"

alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias dots="cd ~/.dotfiles"
alias vrc="nvim ~/.vimrc"
alias wrc="nvim ~/.config/qutebrowser/autoconfig.yml"
alias zrc="nvim ~/.zshrc"
alias trc="nvim ~/.tmux.conf"
alias mrc="nvim ~/.mutt/neomuttrc"
alias irc="nvim ~/.irssi/config"

alias vdev="vim --servername DEV --remote"
alias ff="fzf-fs"

alias ttyw3m="TERM=fbterm w3m"
alias www="w3m https://google.com"
alias tabbed-vimb="tabbed -c vimb -e"
alias news="newsboat --config-file=$HOME/.newsboat/config --url-file=$HOME/.newsboat/urls"
alias nmutt='neomutt'

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'

if which colordiff >/dev/null 2>&1; then
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

# default tmux layout
function tnetsession() {
    tmux new-session -d -s 'netclients'
    tmux new-window -d -k -t netclients:1 'neomutt'
    tmux new-window -d -k -t netclients:2 'irssi'
    tmux new-window -d -k -t netclients:3 'newsboat --config-file=$HOME/.newsboat/config --url-file=$HOME/.newsboat/urls'
}
