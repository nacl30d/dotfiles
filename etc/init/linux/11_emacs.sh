#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

. ${DOTPATH}/etc/lib/vital.sh

if has "emacs"; then
    die "emacs: You have already installed."
    exit 0
fi

if has "yum"; then
    e_arrow "Install emacs25 by Source Build."
    sudo yum -y install ncurses-devel
    curl -LO http://ftp.jaist.ac.jp/pub/GNU/emacs/emacs-25.3.tar.xz
    tar xzvf emacs-25.3.tar.xz
    cd emacs-25.3
    ./configure
    make
    sudo make install
elif has "apt"; then
    e_arrow "Install emacs25 via PPA with Advanced Packaging Tool."
    sudo apt -y install ncurses-dev
    sudo add-apt-repository ppa:kelleyk/emacs
    sudo apt update
    sudo apt -y install emacs25
elif has "apk"; then
else
    die "require: yum or apt"
fi

e_success "emacs: Installed successfully."
exit 0

