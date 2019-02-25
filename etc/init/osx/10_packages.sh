#! /usr/bin/env bash

set -Ceu

if [ -z "$DOTPATH" ]; then
    echo'$DOTPATH not set' >&2
    exit 1
fi


. "$DOTPATH"/etc/lib/vital.sh

cd "$DOTPATH"

e_arrow "Installing brew packages"
brew bundle install

e_success "packages: Installed successfully!"
exit 0

