#! /bin/bash

set -Ceu

THIS_DIR=$(cd $(dirname $0); pwd;)

cd $THIS_DIR

cat >> ./log <<EOF
***
$(date)
***
EOF

echo "start install dotfiles..."

for file in $(ls -a | grep '^\...?*'); do
    [ ${file} == ".DS_Store" ] && continue
    [ ${file} == ".git" ] && continue
    [ ${file} == ".gitignore" ] && continue
    if [ -e $HOME/${file} ]; then
        ln -sv $HOME/dotfiles/${file} $HOME/dot${file} >> ./log
        echo "Made ${file}.dot. This file has already exist: ${file}"
    else
        ln -sv $HOME/dotfiles/${file} $HOME/${file}  >> ./log
        echo "Made symbolic link: ${file}"
    fi
done

cat <<EOF
********************************
DOTFILE SETUP FINISHED! bye.
********************************
EOF
