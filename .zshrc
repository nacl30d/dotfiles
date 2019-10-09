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
automaticcaly_attach_tmux_session() {
    if ! is_interactive_shell; then
        return 1
    fi
    
    if is_screen_running; then
        echo "This is on screen."
        return 0
    elif is_tmux_running; then
        echo "This is on tmux."
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
        tmux new-session && echo "tmux: created new session."
    fi
}

# emacs
function er () {
    emacs "$1" --eval '(setq buffer-read-only t)'
}

# Alias
alias e='emacs'
alias ls='ls --color'
alias la='ls -la'
alias ll='ls -l'
alias grep='grep --color=always -IHn'


## Remote host (or not)
if is_remote_host; then
    PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_host $p_user "
fi
automaticcaly_attach_tmux_session

## OSX or Linux
if is_osx; then
    # alias ls='ls -G'
elif is_linux; then
    # alias ls='ls --color'
fi
