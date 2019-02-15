#! /usr/bin/env bash

set -Cue

. "$DOTPATH"/etc/lib/vital.sh


if ! has "zsh"; then
    echo "Error: require: zsh"
    exit 1;
fi

if ! contains "${SHELL:-}" "zsh"; then
    zsh_path="${which zsh}"

    if ! grep -xq "${zsh_path:=/bin/zsh}" /etc/shells; then
        echo "Error: you should append '$zsh_path' to /etc/shells"
        exit 1
    fi

    if [ -x "$zsh_path" ]; then
        if chsh -s "$zsh_path" "${USER:-root}"; then
            echo "Done: Change shell to '$zsh_path' for '${USER:-root}' successfully"
        else
            echo "Error: cannnot set '$zsh_path' as \$SHELL"
            echo "       Is '$zsh_path' descrived in /etc/shells?"
            echo "       you should run 'chsh -l' now"
            exit 1
        fi

    else
        echo "Error: '$zsh_path': invalid path"
        exit 1
    fi
fi

