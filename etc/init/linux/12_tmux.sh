#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

. ${DOTPATH}/etc/lib/vital.sh

if has "tmux"; then
    e_arrow "tmux: You have already installed."
    exit 0
fi

if has "yum"; then
    e_arrow "Install emacs25 by Source Build."
    sudo yum -y install kernel-devel ncurses-devel
elif has "apt"; then
    e_arrow "Install emacs25 via PPA with Advanced Packaging Tool."
    sudo apt -y install libevent-dev libncurses-dev
elif has "apk"; then
else
    die "require: yum or apt"
fi

e_arrow "Install tmux (latest) via GitHub."
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make


e_success "tmux: Installed successfully."
exit 0

