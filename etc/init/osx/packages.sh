!# /usr/bin/env bash

set -Ceu

if [ -z "$DOTPATH" ]; then
    echo'$DOTPATH not set' >&2
    exit 1
fi


. "$DOTPATH"/etc/lib/vital.sh

cd "$DOTPATH"

brew file install



