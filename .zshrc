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
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
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

# Functions
is_exists() { type "$1" >/dev/null 2>&1; return $?; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_running() { [ ! -z "$TMUX" ]; }
is_interactive_shell() { [ ! -z "$PS1" ]; }

# tmux
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
        tmux new-session -s 'workspace' -c $HOME -d

        for f in $HOME/.tmux/*.sh; do
            bash $f
        done

        tmux attach -t 'workspace'
    fi
}

automaticcaly_attach_tmux_session

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

is_exists 'starship' && eval "$(starship init zsh)"
is_exists 'mise' && eval "$(mise activate zsh)"
is_exists 'fzf' && eval "$(fzf --zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
is_exists 'pnpm' && eval "$(pnpm completion zsh)"
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s ~/.bun/_bun ] && source ~/.bun/_bun

# # volta
# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"

# aws
complete -C "$(brew --prefix)/bin/aws_completer" aws
is_exists 'saml2aws' && eval "$(saml2aws --completion-script-zsh)"

# Bitwarden
is_exists 'bw' && {
    # https://github.com/bitwarden/clients/issues/6689
    alias bw='NODE_OPTIONS="--no-deprecation" bw'
    eval "$(bw completion --shell zsh); compdef _bw bw;"
}

complete -o nospace -C /opt/homebrew/bin/hcp hcp
