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

# GPG over SSH
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
gpgconf --launch gpg-agent
