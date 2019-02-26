#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh


if has "pip3"; then
    e_arrow "installing pip packages."
    pip_pkg='pylint'
    pip3 install --upgrade pip
    pip install $pip_pkg
    e_done "pip packages installed."
fi

if has "npm"; then
    e_arrow "installing npm packages."
    npm_pkg='standard'
    npm update -g npm
    npm install -g $npm_pkg
    e_done "npm packages installed."
fi

exit 0

