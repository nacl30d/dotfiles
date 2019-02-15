#! /usr/bin/env bash

set -Cue

. "$DOTPATH"/etc/lib/vital.sh


# Set timezone
sudo timedatectl set-timezone Asia/Tokyo
