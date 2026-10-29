#!/usr/bin/env bash
# Double-buffered tmux status: render every segment in the background, then
# publish the finished string in one `set -g @status_buffer`, so the status
# line never shows half-updated or blank segments.
# Fully sequential: each round runs the segments that are due, publishes,
# then waits one tick. No process per round besides docker: CPU, RAM,
# network and notifications are read with bash builtins, the wait is a
# `read -t`, and tmux and ping are each one long-lived process.
# Started from tmux.conf. Each copy writes its pid to @status_buffer_owner
# and keeps going only while that is still its own, so a new copy (config
# reload) replaces the running one; it also exits with the tmux server.

trap '' PIPE                # a dead control client must not kill us
exec {tick}<> <(:)          # never readable: `read -t` on it is a builtin sleep

# seconds per round, and how many rounds between updates of each segment
tick_seconds=2
segments=(cpu mem net notif docker ping)
declare -A every=([cpu]=1 [mem]=1 [net]=1 [notif]=1 [docker]=5 [ping]=1)

ping_host=www.google.com
ping_seconds=30             # one long-lived ping, a packet every 30s
ping_retry=15               # rounds between restarts while offline or dead

sep='#[fg=brightred] │ #[default]'
cpu_icon=$''
mem_icon=$'\U000f035b'

# --- tmux control mode -------------------------------------------------------

# one control client for the whole run; it ends when the server goes away
tmux_start() {
    coproc TM { exec tmux -C attach -f ignore-size,no-output 2>/dev/null {tick}>&-; }
    tmux_reply      # the attach itself answers with an empty block
}

# detach explicitly and keep reading until the client is gone: the server
# writes its last messages (%exit) straight into our pipe, and if nobody
# reads them the client never finishes and stays attached forever
tmux_stop() {
    local line
    [[ ${TM[1]} ]] || return
    printf 'detach-client\n' >&"${TM[1]}" 2>/dev/null
    while IFS= read -r -t 2 -u "${TM[0]}" line 2>/dev/null; do :; done
}
trap 'tmux_stop; ping_stop' EXIT
trap exit TERM HUP INT      # run the EXIT trap when killed too

# reads one %begin/%end block into $reply; 1 on %error, 2 when the client is gone
tmux_reply() {
    local line inside=0
    reply=()
    while IFS= read -r -t 5 -u "${TM[0]}" line; do
        case $line in
            '%begin '*) inside=1 ;;
            '%end '*)   return 0 ;;
            '%error '*) return 1 ;;
            '%exit'*)   return 2 ;;
            *)          (( inside )) && reply+=("$line") ;;
        esac
    done
    return 2
}

# runs one tmux command; values are passed single-quoted, so drop any quote
tmux_cmd() {
    [[ ${TM[1]} ]] || return 2
    printf '%s\n' "$1" >&"${TM[1]}" 2>/dev/null || return 2
    tmux_reply
}

# --- segments: each update_<name> sets seg[<name>] ---------------------------

# ping states are all 2 cells wide (❌ is a wide glyph) so the bar never shifts
declare -A seg=([cpu]='' [mem]='' [net]='' [notif]='' [docker]='◼ ? ◻ ?' [ping]='? ')

# sets $col: green below medium, yellow below stress, red above
color() { # value medium stress
    if   (( $1 >= $3 )); then col=red
    elif (( $1 >= $2 )); then col=yellow
    else                      col=green
    fi
}

# busy and total jiffies from the aggregate cpu line
read_cpu() {
    local _ user nice system idle iowait irq softirq steal
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    cpu_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    cpu_busy=$((cpu_total - idle - iowait))
}

# fixed width ("%3d%%") so the bar never shifts as numbers change
update_cpu() {
    local dt cpu
    read_cpu
    (( dt = cpu_total - prev_total, cpu = dt > 0 ? 100 * (cpu_busy - prev_busy) / dt : 0 ))
    prev_busy=$cpu_busy prev_total=$cpu_total
    color $cpu 30 80
    printf -v 'seg[cpu]' '#[fg=%s]%s %3d%%#[default]' "$col" "$cpu_icon" "$cpu"
}

update_mem() {
    local key val _ total avail mem
    while read -r key val _; do
        case $key in
            MemTotal:)     total=$val ;;
            MemAvailable:) avail=$val; break ;;
        esac
    done < /proc/meminfo
    (( mem = 100 * (total - avail) / total ))
    color $mem 60 85
    printf -v 'seg[mem]' '#[fg=%s]%s %3d%%#[default]' "$col" "$mem_icon" "$mem"
}

# rx/tx bytes summed over physical interfaces (skips lo, docker, bridges, vpn)
read_net() {
    local line name rx tx _
    net_rx=0 net_tx=0
    while read -r line; do
        [[ $line == *:* ]] || continue
        name=${line%%:*}
        [[ -e /sys/class/net/$name/device ]] || continue
        read -r rx _ _ _ _ _ _ _ tx _ <<< "${line#*:}"
        (( net_rx += rx, net_tx += tx ))
    done < /proc/net/dev
    net_time=${EPOCHREALTIME/./}
}

# sets $rate: bytes/s as a fixed 8-char field, "556  B/s", " 12 KB/s"
fmt_rate() {
    local v=$1 u
    for u in ' B' KB MB GB; do
        (( v < 1000 )) && break
        (( v /= 1024, v == 0 && (v = 1) ))
    done
    printf -v rate '%3d %s/s' "$v" "$u"
}

update_net() {
    local us up
    read_net
    (( us = net_time - prev_time, us <= 0 && (us = 1) ))
    fmt_rate $(( (net_tx - prev_tx) * 1000000 / us )); up=$rate
    fmt_rate $(( (net_rx - prev_rx) * 1000000 / us ))
    seg[net]="$up / $rate"
    prev_rx=$net_rx prev_tx=$net_tx prev_time=$net_time
}

update_notif() {
    local notifications
    seg[notif]=
    [[ -e ~/.tmux-notify ]] || return
    mapfile -t notifications < ~/.tmux-notify
    (( ${#notifications[@]} )) && seg[notif]="#[fg=red,bold][${#notifications[@]}]#[default]"
}

# one docker call, states counted here
update_docker() {
    local state running=0 stopped=0
    type -P docker >/dev/null || return
    while read -r state; do
        case $state in
            running|restarting) (( running++ )) ;;
            *)                  (( stopped++ )) ;;
        esac
    done < <(docker ps -a --format '{{.State}}' 2>/dev/null {tick}>&-)
    seg[docker]="◼ $running ◻ $stopped"
}

# one ping for the whole run; -O reports a missing reply before the next
# packet, -n skips a reverse lookup per reply
ping_start() {
    exec {ping_fd}< <(exec ping -n -O -i "$ping_seconds" "$ping_host" 2>&1 {tick}>&-)
    ping_pid=$! ping_started=$round
}

ping_stop() {
    [[ $ping_pid ]] && kill "$ping_pid" 2>/dev/null
    [[ $ping_fd ]] && exec {ping_fd}<&-
    ping_pid= ping_fd=
}

# reads whatever ping printed since last round, never waiting for it
update_ping() {
    local line rc
    [[ $ping_fd ]] || ping_start
    # rc must come from read itself: after `done`, $? is the loop's status
    while IFS= read -r -t 0.01 -u "$ping_fd" line; rc=$?; (( rc == 0 )); do
        case $line in
            *' bytes from '*)  seg[ping]='✔ ' ;;
            *'no answer yet'*|*nreachable*|*'not known'*|*'failure in name resolution'*)
                               seg[ping]='❌' ;;
        esac
    done
    # EOF (rc <= 128, not a timeout): ping exited, e.g. the lookup failed.
    # While offline also restart it, as it resolves the host only once.
    if (( rc <= 128 )) || [[ ${seg[ping]} == '❌' ]]; then
        (( rc <= 128 )) && seg[ping]='❌'
        if (( round - ping_started >= ping_retry )); then
            ping_stop; ping_start
        fi
    fi
}

publish() {
    local c buffer
    buffer="#[fg=white,bg=colour236] ${seg[docker]} #[fg=white,bg=black]${sep}${seg[cpu]} ${seg[mem]}${sep}${seg[ping]} ${seg[net]}"
    tmux_cmd "set -g @status_buffer '${buffer//\'/}'"
    tmux_cmd "set -g @status_buffer_tail '${seg[notif]//\'/}'"
    tmux_cmd "list-clients -F '#{client_name}'" || return
    for c in "${reply[@]}"; do tmux_cmd "refresh-client -S -t '$c'"; done
}

# --- main loop ---------------------------------------------------------------

tmux_start || exit 0
tmux_cmd "set -g @status_buffer_owner $$"
read_cpu; prev_busy=$cpu_busy prev_total=$cpu_total
read_net; prev_rx=$net_rx prev_tx=$net_tx prev_time=$net_time
read -t 1 -u $tick

round=0
while :; do
    # the client also leaves when its session closes: reconnect, and stop
    # only when that fails because the server is gone
    if [[ -z $TM_PID ]] || ! kill -0 "$TM_PID" 2>/dev/null; then
        wait "$TM_PID" 2>/dev/null
        tmux_start || break
    fi

    # a newer copy has taken over (a failed query just retries next round)
    if tmux_cmd "show -gv @status_buffer_owner"; then
        [[ ${reply[0]} == "$$" ]] || break
    fi

    for s in "${segments[@]}"; do
        (( round % every[$s] == 0 )) && update_$s
    done
    publish

    (( round++ ))
    read -t $tick_seconds -u $tick
done
