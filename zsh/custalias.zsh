##################################################################
# Aliases

# Set up auto extension stuff
alias -s net=$BROWSER
alias -s gz=tar -xzvf
alias -s PKGBUILD=$EDITOR

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
#alias fe='$FINDER -type f | xargs grep'
alias xterm='xterm -fg white -bg black'
alias c="clear"
alias mem="free -m"

alias mux="tmuxinator"
alias mjn="make -j$(nproc)"

export SSH_JOB_FINISH_PORT=2222

alias -g _E='|$EDITOR -'
alias -g _N='1> /dev/null'
alias -g _T=';~/.tmux/tmux-notifications/bin/tmux-notify "Alert"'
alias -g _A='; echo "done on $PWD" | netcat 127.0.0.1 $SSH_JOB_FINISH_PORT -q 0'

function ssh_job_listen() {
    PORT=${1:-$SSH_JOB_FINISH_PORT}
    while true;
    do
        SUM=$(netcat -l -p $PORT)
        notify-send "$SUM"
    done
}

alias ssh='ssh -R $SSH_JOB_FINISH_PORT:127.0.0.1:$SSH_JOB_FINISH_PORT'
#alias sshfs='sshfs -C -o reconnect'
alias sshports="netstat -tpln | grep ssh"
alias ssshports="sudo netstat -tpln | grep ssh"
alias scp="scp -C"

alias sifconfig='sudo ifconfig'
alias siptables='sudo iptables'

if type "pacman" > /dev/null; then
    alias spi='sudo pacman -S'
    alias spu='sudo pacman -Syu'
    alias pS='pacman -Ss'
    alias spr='sudo pacman -Rcns'
elif type "aptitude" > /dev/null; then
    alias sai='sudo apt install'
    alias aS='aptitude search'
    alias saR='sudo apt remove'
    alias sau='sudo apt update'
    alias saup='sudo apt upgrade'
fi

alias v='vim'
alias e="$EDITOR"
alias sv='sudo vim'
alias se='sudo nvim'
# makepkg -sri
alias ee='nvim --listen `tmux display -p "/tmp/nvimsocket.#S.#I"` -c "set noautochdir" -c "Files"'
alias eg='$EDITOR -c "set noautochdir" -c "Ag"'
alias eh='$EDITOR -c "set noautochdir" -c "History"'
alias ew='nvim --server `tmux display -p "/tmp/nvimsocket.#S.#I"` --remote'

alias ipy='python3'

function ag_histo {
    ag -o --nofilename --nobreak "$1" | sort | uniq -c | sort -nrk1
}

#function fzfvim() {
#  local files
#  IFS=$'\n' files=($(fzf-tmux --query="$@" --multi --select-1 --exit-0))
#  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
#}
#function prepend_vim() {
#    BUFFER="fzfvim $BUFFER"
#    zle accept-line-and-down-history
#}
#zle -N prepend_vim

# Add character directly:
#bindkey -s '^e' '\n'

function replace_vim_eg {
    BUFFER=" eg"
    zle accept-line-and-down-history
}
function replace_vim_ee {
    BUFFER=" ee"
    zle accept-line-and-down-history
}
function replace_vim_eh {
    BUFFER=" eh"
    zle accept-line-and-down-history
}
function replace_gd_origin {
    BUFFER=" gd origin"
    zle accept-line-and-down-history
}
zle -N replace_vim_ee
zle -N replace_vim_eg
zle -N replace_vim_eh
zle -N replace_gd_origin

bindkey '^g' replace_vim_eg
bindkey '^e' replace_vim_ee
bindkey '^h' replace_vim_eh
bindkey '^f' replace_gd_origin

## Git
alias gbranch='git branch --sort=-committerdate'
alias gam='git commit -a --amend'
# Usage: glog -10 to see last 10
alias glog='git --no-pager log --pretty="format:%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(30,trunc)%ad %C(auto,green)%<(15,trunc)%aN%C(auto,reset)%s%C(auto)%d" --reverse'
alias gcom='git commit -am'
alias gpush='git push'
alias gpull='git pull --rebase'
alias gclone='git clone --depth 1'
alias gfetch='git fetch'
alias gsw='git switch'
alias gconf='git status --short | grep -E "^(.U|U.|AA|DD) "'
#alias ginit='git submodule update --init --recursive'
#alias gup='git submodule foreach "git fetch && git pull"'
alias gup='git submodule update --init --recursive --remote'
alias gls='git ls-tree --name-only HEAD | xargs $aliases[ls] -d'
alias gtree='git log --graph --oneline --all'
alias gurl='git remote get-url'
alias gstat='git diff --stat --color'
alias gcontrib='git shortlog -s -n'
alias gpatch='git --no-pager diff'

alias grep='grep --color'
alias tree='tree -C'

## Kubernetes
alias k="kubectl"
alias kdelete="kubectl delete -f"
alias kpods="kubectl get pod -o wide"
alias ksvcs="kubectl get services -o wide"
alias kdesc="kubectl describe pod"
function kexec {
    kubectl exec -n $1 -it $2 -- sh
}
function ktop {
    watch -n 1 kubectl top pods $1
}

alias ag="ag --path-to-ignore ~/.ignore"

## Docker
alias dbuild='docker build . -t'
alias dls='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" -a'
alias dkill='docker kill'
alias drm='docker rm'
alias dims='docker image ls --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}"'
alias dtop='docker stats'
alias dports='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a'
alias dclean='docker volume prune ; docker system prune'

#alias clean='go clean --modcache ; go clean --cache ; cargo cache --gc --autoclean'
alias clean='go clean --modcache ; go clean --cache'
alias update='saup && goup update'

export DOCKER_SHARE_HIST_ARGS="-v $HOME/.docker/ash_history:/root/.ash_history -v $HOME/.docker/sh_history:/root/.sh_history -v $HOME/.docker/bash_history:/root/.bash_history -v $HOME/.docker/zsh_history:/root/.zsh_history"

function dsh {
    docker exec -ti $1 sh
}
function _dsh {
    _arguments -C '*::containerid:->ids'
    case "$state" in
        ids)
            val_list=($(docker container ls -a --format "{{.ID}}"))
            disp_list=($(docker container ls -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | sed 1d | sed 's/\s/_/g'))
            _wanted tag expl 'containers' compadd -o nosort -d disp_list $val_list
esac
}
compdef _dsh dsh

function dish {
    docker run $DOCKER_SHARE_HIST_ARGS -ti --entrypoint sh $1
}
function _dish {
    _arguments -C '*::imageid:->ids'
    case "$state" in
        ids)
            val_list=($(docker image list --format "{{.ID}}"))
            disp_list=($(docker image list --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | sed 1d | sed 's/\s/_/g'))
            _wanted tag expl 'image' compadd -o nosort -d disp_list $val_list
esac
}
compdef _dish dish

alias smount="sudo mount"
alias sumount="sudo umount"
alias srcconf="sudo rcconf"
alias pwdb="pwman3"
alias sshut="sudo shutdown -h 0"
alias sreboot="sudo reboot"

alias arduino="arduino-asm"
alias cb='cargo build'
alias cr='cargo run'
alias cx='cargo xtask'
alias ct='RUST_MIN_STACK=8388608 cargo test'

function t() {
    tree $1 -shDFCL 1 | grep --color=always -E '\[.*\]|$'
}

alias ll="ls -haltr"
alias du="du -d 1 -h"
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
alias vrc="$EDITOR ~/.vimrc"
alias wrc="$EDITOR ~/.config/qutebrowser/autoconfig.yml"
alias zrc="$EDITOR ~/.zshrc"
alias trc="$EDITOR ~/.tmux.conf"
alias mrc="$EDITOR ~/.mutt/neomuttrc"
alias irc="$EDITOR ~/.irssi/config"

alias fd="fd -H"

alias ttyw3m="TERM=fbterm w3m"
alias news="newsboat --config-file=$HOME/.newsboat/config --url-file=$HOME/.newsboat/urls"
alias nmutt='neomutt'

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'

alias hist='f() { echo "`history -i | tail -n $1`\n`date "+ NOW: %Y-%m-%d %H:%M"`" | grep -E --color "[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+"};f'

if type "colordiff" > /dev/null; then
  alias diff="colordiff"
fi

# Go back (..) n times
cdn () { pushd .; for ((i=1; i<=$1; i++)); do cd ..; done; pwd; }

# Go up until reaching $1, ie: cdu home
function cdu {
    cd "${PWD%/$1/*}/$1";
}
function _cdu {
    _arguments -C '*::filename:->files'
    case "$state" in
        files)
            pwd_list=(${(s:/:)PWD})
            _wanted -V values expl 'files' compadd $pwd_list
            ;;
esac
}
compdef _cdu cdu

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
