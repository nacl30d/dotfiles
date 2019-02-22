#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

. ${DOTPATH}/etc/lib/vital.sh


PACKAGES="git zsh emacs tmux curl gcc tree wget emacs-mozc-bin emacs-mozc"

if has "yum"; then
    e_arrow "Install packages with Yellowdog Updater Modified."
    sudo yum update
    sudo yum -y install $PACKAGES
elif has "apt"; then
    e_arrow "Install packages with Advanced Packaging Tool."
    sudo apt update && sudo apt upgrade
    sudo apt -y install $PACKAGES
elif has "apk"; then
    e_arrow "Install packages with Alpine Packages."
    apk add $PACKAGES
else
    die "require: yum or apt"
fi

e_success "packages: Installed successfully."
exit 0

