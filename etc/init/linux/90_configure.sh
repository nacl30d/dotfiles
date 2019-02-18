#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPAH" ]; then
    echo '$DOTPAH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh


# Set timezone
e_arrow "Setting up timezone"
sudo timedatectl set-timezone Asia/Tokyo

# add locale setting and so on...

e_success "configure: successfully!"
exit 0

