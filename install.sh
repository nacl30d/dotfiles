#! /bin/bash

set -Ceu

THIS_DIR=$(cd $(dirname $0); pwd;)

cd $THIS_DIR

echo "start install dotfiles..."

for file in $(find . -type f -name ".??*" -exec basename {} \;); do
    [ ${file} == ".DS_Store" ] && continue
    [ ${file} == ".gitignore" ] && continue
    if [ -e $HOME/${file} ]; then
        ln -sv $HOME/dotfiles/${file} $HOME/dot${file}
#        echo "Made ${file}.dot. This file has already exist: ${file}"
    else
        ln -sv $HOME/dotfiles/${file} $HOME/${file}
#        echo "Made symbolic link: ${file}"
    fi
done

cat <<EOF
********************************
DOTFILE SETUP FINISHED! bye.
********************************
EOF
