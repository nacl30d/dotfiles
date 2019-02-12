#!/usr/bin/env bash


set -Ceu

. "$DOTPATH"/etc/lib/vital.sh

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

for script in "$DOTPATH"/etc/init/$(get_os)/*.sh
do
    if [ -f "$script" ]; then
        echo "-> $(basename $script)"
        bash $script
    else
        continue
    fi
done

echo "Done. Bye!"
exit 0
