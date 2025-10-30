exists() { type "$1" >/dev/null 2>&1; return $?; }

exists 'starship' && eval "$(starship init zsh)"
exists 'mise' && eval "$(mise activate zsh)"
# exists 'xcenv' && eval "$(xcenv init -)"  # Too slow
exists 'fzf' && eval "$(fzf --zsh)"
exists 'orb' && source ~/.orbstack/shell/init.zsh

# aws
exists 'aws' && complete -C "$(brew --prefix)/bin/aws_completer" aws
exists 'saml2aws' && eval "$(saml2aws --completion-script-zsh)"

# Terraform
exists 'hcp' && complete -o nospace -C "$(brew --prefix)/bin/hcp" hcp

# pnpm
exists 'pnpm' && {
    export PNPM_HOME="$HOME/Library/pnpm"
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
}

# bun
exists 'bun' && {
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s ~/.bun/_bun ] && source ~/.bun/_bun
}
