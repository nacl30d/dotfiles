#! /usr/bin/env bash

set -Cue

. ${DOTPATH}/etc/lib/vital.sh

PACHAGES="git zsh emacs tmux curl tree wget "

if has "yum"; then
echo "Install packages with Yellowdog Updater Modified."
sudo yum update
sudo yum -y install $PACHAGES
elif has "apt"; then
echo "Install packages with Advanced Packaging Tool."
sudo apt update && sudo apt upgrade
sudo apt -y install $PACHAGES
else
echo "Error: require: yum or apt"
exit 1
fi

echo "Done: packages: Installed successfully."
