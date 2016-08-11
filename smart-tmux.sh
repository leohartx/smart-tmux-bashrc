#!/bin/bash
if [ -z "$TMUX" ] && [ $(which tmux | wc -c ) -gt 0 ]; then
    show_selectable_sessions() {
        if [ $(tmux ls | grep -v "(attached)" | wc -l) -gt 0 ]; then
            echo "Please select tmux session below or type a new session name."
            echo "Press C-c to quit to normal Terminal"
            tmux ls | grep -v "(attached)" | while read -r line; do
                echo "$line"
            done
        fi
    }

    attach_session() {
        if [ $(tmux ls | grep -v "(attached)" | wc -l) -gt 0 ]; then
            read -p "Sesion name : " session_name
        else
            read -p "Start new session : " session_name
        fi

        if [ $(tmux ls | grep "^$session_name" | wc -l) -gt 0 ]; then
            if [ $(tmux ls | grep "^$session_name" | grep "(attached)" | wc -l) -gt 0 ]; then
                echo "cant re-attach exisiting session"
            else
                tmux attach -t $session_name
            fi
        else
            tmux new-session -s $session_name
        fi
    }

    # init tmux
    if tmux info &> /dev/null; then 
        session_count="$(tmux ls | wc -l)"
        detached_count="$(tmux ls | grep -v '(attached)' | wc -l)"
    else
        session_count=0
    fi

    if [ "$session_count" -eq "0" ]; then
        tmux new-session -s "main"
    elif [ "$session_count" -eq "1" ] && [ "$detached_count" -eq "1" ]; then
        tmux attach # re-attach to the only session
    else
        show_selectable_sessions
        attach_session
    fi
fi
