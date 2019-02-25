#!/usr/bin/env bash

set -Ceu

if [ -z "$DOTPATH" ]; then
    echo'$DOTPATH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh


if ! is_osx; then
    die "This script is only supported with osx."
fi

if has "brew"; then
    e_arrow "Checking your brew"
    brew doctor
    if [ "$?" = 0  ]; then
        e_ok "brew"
        exit 0
    else
        e_warning "Your brew looks like having some problems"
        exit 0
    fi
fi

if ! has "ruby"; then
    die "require: ruby"
fi

e_arrow "Installing brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if has "brew"; then
    sudo mkdir -p /usr/locasl/Frameworks
    e_arrow "Checking your brew"
    brew doctor;
else
    die "brew: faild to install."
fi

e_success "brew: installed successfully."
exit 0

