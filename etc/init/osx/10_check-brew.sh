#!/usr/bin/env bash

set -Ceu

. "$DOTPATH"/etc/lib/vital.sh

if ! is_osx; then
    echo "error: this script is only supported with osx."
    exit 1
fi

if has "brew"; then
    echo "OK: brew is installed."
    exit 0
fi

if ! has "ruby"; then
    echo "error: require: ruby"
    exit 1
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if has "brew"; then
    brew doctor;
else
    echo "error: brew: faild to install."
    exit 1
fi

"brew: installed successfully."
exit 0
