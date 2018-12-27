
export LANG=ja_JP.UTF-8

# 色を使用
autoload -Uz colors
colors

# lsに色を使用
export LSCOLORS='exfxxxxxcxxxxxxxxxexex'
alias ls='ls -G'
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

PROMPT='
%F{cyan}[%~]%f ${vcs_info_msg_0_}
%(?.%F{yellow}.%F{magenta})%n@%m%f %# '

# Alias
alias e='emacs'
alias la='ls -la'
alias ll='ls -l'
alias curl-h='curl -D - -s -o /dev/null'
alias php-s='php -S localhost:8000'
alias op-dev='cd ~/oi/officepass/staging-project'
alias oihp-dev='cd ~/oi/homepage/html'
alias oihp-pull='rsync -av -e ssh oihp:/usr/share/nginx/html/ ~/oi/homepage/html'
alias oihp-push='rsync -av -e ssh ~/oi/homepage/html/ oihp:/usr/share/nginx/html'
alias web='cd ~/web/d-salt.net/d-salt.net/'
#alias webs='sudo php-fpm && sudo nginx &'
alias webs='sudo nginx &'
#alias stop-webs="ps aux | grep php-fpm | grep Ss | grep -v grep | awk '{print \$2}' | xargs sudo kill && ps aux | grep nginx | grep master | grep -v grep | awk '{print \$2}' | xargs sudo kill"
alias stop-webs="ps aux | grep nginx | grep master | grep -v grep | awk '{print \$2}' | xargs sudo kill"
alias cs="cd ~/www/coursespace/"
alias turtle="open ~/RonproEditor/RonproEditor.jar"
alias alg="docker run -it -v /Users/d-salt/Box\ Sync/Aoyama/StudentAssistant/2018/ads/docker:/code ads bash"