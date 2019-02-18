#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh


if ! has "zsh"; then
    die "require: zsh"
fi

if ! contains "${SHELL:-}" "zsh"; then
    zsh_path="$(which zsh)"

    if ! grep -xq "${zsh_path:=/bin/zsh}" /etc/shells; then
        die "You should append '$zsh_path' to /etc/shells"
    fi

    if [ -x "$zsh_path" ]; then
        e_arrow "Changing default shell to zsh"
        if chsh -s "$zsh_path" "${USER:-root}"; then
            e_success " Change shell to '$zsh_path' for '${USER:-root}' successfully"
        else
            die "Cannnot set '$zsh_path' as \$SHELL \n
                   Is '$zsh_path' descrived in /etc/shells? \n
                   you should run 'chsh -l' now"
        fi
    else
        die "'$zsh_path': invalid path"
    fi
fi

