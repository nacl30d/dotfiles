
export LANG=ja_JP.UTF-8

# 色を使用
autoload -Uz colors
colors

# lsに色を使用
export LSCOLORS='exfxxxxxcxxxxxxxxxexex'
export LS_COLORS='di=34:ln=35:ex=32'
zstyle 'completion:*' list-colors 'di=34' 'ln=35' 'ex=32'

# 補完
autoload -U compinit;
compinit -C

# 小文字でも大文字でもマッチ（補完）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補に色を付ける
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100
export SAVEHIST=10000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY



# emacsキーバインド
bindkey -e


# git設定
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

p_dir='%F{cyan}[%~]%f'
p_vcs='${vcs_info_msg_0_}'
p_host='%F{yellow}(%m)%f'
p_user='%(?.%F{green}.%F{magenta})%n %#%f'
PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_user "

is_exists() { type "$1" >/dev/null 2>&1; return $?; }
is_osx() { [[ $OSTYPE == darwin* ]]; }
is_linux() { [[ $OSTYPE == linux* ]]; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_running() { [ ! -z "$TMUX" ]; }
is_interactive_shell() { [ ! -z "$PS1" ]; }
is_remote_host() { [[ ! -z "${REMOTEHOST}" || ! -z "${SSH_CONNECTION}" ]]; }

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

# Alias
alias e='emacs'
alias la='ls -la'
alias ll='ls -l'
alias curl-h='curl -D - -s -o /dev/null'


## remote host or not
if is_remote_host; then
    PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_host $p_user "
    automaticcaly_attach_tmux_session
fi


## osx or linux
if is_osx; then
    alias ls='ls -G'
elif is_linux; then
    alias ls='ls --color'
fi


# Added by Krypton
export GPG_TTY=$(tty)
