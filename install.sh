#! /bin/bash

set -Ceu

THIS_DIR=$(cd $(dirname $0); pwd;)

cd $THIS_DIR

LOG_DIR="$THIS_DIR/log"
LOG_FILE="$LOG_FILE/$(date +%Y%m%d%H%M).log"

echo "start install dotfiles..."

for file in $(ls -a | grep '^\...?*'); do
    [ ${file} == ".DS_Store" ] && continue
    [ ${file} == ".git" ] && continue
    [ ${file} == ".gitignore" ] && continue
    if [ -e $HOME/${file} ]; then
        ln -sv $HOME/dotfiles/${file} $HOME/dot${file} >> $LOG_FILE
        echo "Made ${file}.dot. This file has already exist: ${file}"
    else
        ln -sv $HOME/dotfiles/${file} $HOME/${file}  >> $LOG_FILE
        echo "Made symbolic link: ${file}"
    fi
done

cat <<EOF
********************************
DOTFILE SETUP FINISHED! bye.
********************************
EOF
