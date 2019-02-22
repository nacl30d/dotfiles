#!/usr/bin/env bash

ostype() {
    uname | lower
}

os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='osx'     ;;
        *'bsd'*)    PLATFORM='bsd'     ;;
        *)          PLATFORM='unknown' ;;
    esac
}

is_osx() {
    os_detect
    if [ "$PLATFORM" = "osx" ]; then
        return 0
    else
        return 1
    fi
}

is_linux() {
    os_detect
    if [ "$PLATFORM" = "linux" ]; then
        return 0
    else
        return 1
    fi
}

is_bsd() {
    os_detect
    if [ "$PLATFORM" = "bsd" ]; then
        return 0
    else
        return 1
    fi
}

# get_os returns OS name of the platform that is runnning
get_os() {
    local os
    for os in osx linux bsd; do
        if is_$os; then
            echo $os
        fi
    done
}

is_exists() {
    type "$1" > /dev/null 2>&1
    return $?
}

has() {
    is_exists "$@"
}

contains() {
    string="$1"
    substring="$2"
    if [ "${string#*$substring}" != "$string" ]; then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

lower() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:upper:]" "[:lower:]"
}

upper() {
    if [ $# -eq 0 ]; then
        cat <&0
    elif [ $# -eq 1 ]; then
        if [ -f "$1" -a -r "$1" ]; then
            cat "$1"
        else
            echo "$1"
        fi
    else
        return 1
    fi | tr "[:lower:]" "[:upper:]"
}

e_arrow() {
    printf " \033[37;1m%s\033[m\n" "==> $*"
}

e_arrow_green() {
    printf " \033[32;1m%s\033[m\n" "==> $*"
}

e_arrow_blue() {
    printf " \033[34;1m%s\033[m\n" "==> $*"
}

e_ok() {
    printf " \033[37;1m%s...\033[32mOK\033[m" "✔  $*"
}

e_success() {
    printf " \033[32m%s\033[m" "$*"
}

e_done() {
    printf " \033[37;1Done! %s\033[m" "$*"
}

e_info() {
    printf " \033[36mInfo: %s\033[m\n" "$*"
}

e_warning() {
    printf " \033[33mWarning: %s\033[m\n" "$*"
}

e_error() {
    printf " \033[31mError: %s\033[m\n" "$*" 1>&2
}

die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}
