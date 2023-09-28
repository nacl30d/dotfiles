# Use color
autoload -Uz colors
colors

# Color for ls
export LSCOLORS='exfxxxxxcxxxxxxxxxexex'
export LS_COLORS='di=34:ln=35:ex=32'
zstyle 'completion:*' list-colors 'di=34' 'ln=35' 'ex=32'

# Color for less
export LESSOPEN='| src-hilite-lesspipe.sh %s'
export LESS='-IRM'

# Complement
autoload -U compinit;
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# History
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY

# Emacs keybind
bindkey -e

# Git status
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

# Prompt
p_dir='%F{cyan}[%~]%f'
p_vcs='${vcs_info_msg_0_}'
p_host='%F{yellow}(%m)%f'
p_user='%(?.%F{green}.%F{magenta})%n %#%f'
PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_user "

# Functions
is_exists() { type "$1" >/dev/null 2>&1; return $?; }
is_osx() { [[ $OSTYPE == darwin* ]]; }
is_linux() { [[ $OSTYPE == linux* ]]; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_running() { [ ! -z "$TMUX" ]; }
is_interactive_shell() { [ ! -z "$PS1" ]; }
is_remote_host() { [[ ! -z "${REMOTEHOST}" || ! -z "${SSH_CONNECTION}" ]]; }

# tmux
echo_tmux() {
    echo ' _____ __  __ _   ___  __'
    echo '|_   _|  \/  | | | \ \/ /'
    echo '  | | | |\/| | | | |\  / '
    echo '  | | | |  | | |_| |/  \ '
    echo '  |_| |_|  |_|\___//_/\_\'
}

automaticcaly_attach_tmux_session() {
    if ! is_interactive_shell; then
        return 1
    fi

    if is_screen_running; then
        echo "This is on screen."
        return 0
    elif is_tmux_running; then
        echo_tmux
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
        tmux new-session -s 'workspace' -c $HOME -d

        for f in $HOME/.tmux/*.sh; do
            bash $f
        done

        tmux attach -t 'workspace'
    fi
}

function run_my_modulars () {
    for PROFILE_SCRIPT in /etc/profile.d/*.sh; do
        source $PROFILE_SCRIPT
    done
}

# emacs
function er () {
    emacs "$1" --eval '(setq buffer-read-only t)'
}

# SSH over GPG
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
gpgconf --launch gpg-agent


function build-minute () {
    if [ $# = 0 ]; then
        exit 1;
    elif [ $# = 1 ]; then
        FILENAME=${1%.*}
    elif [ $# = 2 ]; then
        FILENAME=$2
    fi
    mkdir $FILENAME
    pandoc -d md2pdf -o ${FILENAME}/${FILENAME}.pdf $1
    pdftoppm -png ${FILENAME}/${FILENAME}.pdf ${FILENAME}/${FILENAME}
}

# Alias
alias e='emacsclient -t -a ""'
alias ls='ls --color'
alias la='ls -la'
alias ll='ls -l'
alias grep='grep --color=always -IHn'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

## Load files
ZSHHOME="${HOME}/.zsh"
if [ -d $ZSHHOME ]; then
    for f in ${ZSHHOME}/*.zsh; do
        source "$f"
    done
fi

## Remote host (or not)
if is_remote_host; then
    PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_host $p_user "
fi
automaticcaly_attach_tmux_session
# run_my_modulars

## OSX or Linux
if is_osx; then
    # alias ls='ls -G'
elif is_linux; then
    # alias ls='ls --color'
fi

is_exists 'starship' && eval "$(starship init zsh)"
is_exists 'nodenv' && eval "$(nodenv init -)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
