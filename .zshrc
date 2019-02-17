
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

[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT=$'\n'"$p_dir $p_vcs"$'\n'"$p_host $p_user "
;

# Alias
alias e='emacs'
alias la='ls -la'
alias ll='ls -l'
alias curl-h='curl -D - -s -o /dev/null'


## OS別
case ${OSTYPE} in
    darwin*)
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls --color'
    ;;
esac


# Added by Krypton
export GPG_TTY=$(tty)
