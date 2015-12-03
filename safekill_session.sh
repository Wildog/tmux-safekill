#!/usr/bin/env bash
set -e

function safe_end_procs {
    old_ifs="$IFS"
    IFS=$'\n'
    panes=$(tmux list-panes -s -F "#{pane_id} #{pane_current_command}")
    for pane_set in $panes; do
        pane_id=$(echo "$pane_set" | awk -F " " '{print $1}')
        pane_proc=$(echo "$pane_set" | awk -F " " '{print tolower($2)}')
        cmd="C-c"
        if [[ "$pane_proc" == "vim" ]] || [[ "$pane_proc" == "vi" ]]; then
            cmd='":qa" Enter'
        elif [[ "$pane_proc" == "mc" ]]; then
            cmd='"exit" Enter "exit" Enter'
        elif [[ "$pane_proc" == "htop" ]]; then
            cmd='"q" "exit" Enter'
        elif [[ "$pane_proc" == "man" ]] || [[ "$pane_proc" == "less" ]]; then
            cmd='"q"'
        elif [[ "$pane_proc" == "bash" ]] || [[ "$pane_proc" == "zsh" ]] || [[ "$pane_proc" == "fish" ]]; then
            cmd='C-c C-u "exit" Enter'
        elif [[ "$pane_proc" == "ssh" ]]; then
            cmd='Enter "~."'
        elif [[ "$pane_proc" == "psql" ]]; then
            cmd='Enter "\q"'
        fi
        echo $cmd | xargs tmux send-keys -t "$pane_id"
        if [[ "$pane_proc" == "vim" ]] || [[ "$pane_proc" == "vi" ]]; then
            echo '"exit" Enter' | xargs tmux send-keys -t "$pane_id"
        fi
    done
    IFS="$old_ifs"
}

safe_end_tries=0
while [ $safe_end_tries -lt 1 ]; do
    safe_end_procs
    safe_end_tries=$[$safe_end_tries+1]
    sleep 0.75
done
tmux send-message "Could not end all processes, you're on your own now!"
