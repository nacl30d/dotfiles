is_exists() { type "$1" >/dev/null 2>&1; return $?; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_running() { [ ! -z "$TMUX" ]; }
is_interactive_shell() { [ ! -z "$PS1" ]; }

automaticcaly_attach_tmux_session() {
    if ! is_interactive_shell; then
        return 1
    fi

    if is_screen_running; then
        echo "This is on screen."
        return 0
    elif is_tmux_running; then
        return 0
    else
        ! is_exists 'tmux' && return 1
    fi

    if tmux has-session >/dev/null 2>&1; then
        tmux list-sessions
        echo -n "Tmux: attach? [Y/n/num]: "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
            tmux attach-session
            if [ $? = 0 ]; then
                echo "$(tmux -V) attached session."
                return 0
            fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
            tmux attach -t "$REPLY"
            if [ $? = 0 ]; then
                echo "$(tmux -V) attached session."
                return 0
            fi
        fi
    else
        DEFAULT_SESSION='workspace'
        tmux new-session -s $DEFAULT_SESSION -c $HOME -d

        TMUXHOME="$HOME/.tmux"
        if [ -d $TMUXHOME ]; then
            for f in $TMUXHOME/*.sh; do
                source "$f"
            done
        fi

        tmux attach -t $DEFAULT_SESSION
    fi
}

automaticcaly_attach_tmux_session
