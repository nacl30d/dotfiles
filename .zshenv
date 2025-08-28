setopt no_global_rcs
export LANG=ja_JP.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8

export GPG_TTY=${TTY}
export GPG_KEYID=60518F98A502A1FB

if [ -f /opt/homebrew/bin/brew ]; then
    BREW_PREFIX=/opt/homebrew
elif [ -f /opt/homebrew/bin/brew ]; then
    BREW_PREFIX=/usr/local/homebrew
fi

path=(
    $BREW_PREFIX/bin(N-/)
    $BREW_PREFIX/sbin(N-/)
    $BREW_PREFIX/opt/curl/bin(N-/)
    $BREW_PREFIX/opt/gawk/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/gnu-sed/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/grep/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/make/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/coreutils/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/findutils/libexec/gnubin(N-/)
    $BREW_PREFIX/opt/unzip/bin(N-/)
    $BREW_PREFIX/opt/kotlin-lsp/libexec(N-/)
    /Library/TeX/texbin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /usr/bin(N-/)
    /usr/sbin(N-/)
    /bin(N-/)
    /sbin(N-/)
    $HOME/bin(N-/)
    $HOME/go/bin(N-/)
    $HOME/Library/Android/sdk/platform-tools(N-/)
    $HOME/.local/bin(N-/)
)

fpath=(
    $BREW_PREFIX/share/zsh/site-functions
    $fpath
)

export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"

typeset -xTU PKG_CONFIG_PATH pkg_config_path
pkg_config_path=(
    $BREW_PREFIX/opt/curl/lib/pkgconfig(N-/)
    $BREW_PREFIX/opt/expat/lib/pkgconfig(N-/)
    $BREW_PREFIX/opt/libffi/lib/pkgconfig(N-/)
    $BREW_PREFIX/opt/libxml2/lib/pkgconfig(N-/)
    $BREW_PREFIX/opt/sqlite/lib/pkgconfig(N-/)
    $BREW_PREFIX/opt/zlib/lib/pkgconfig(N-/)
)

export EDITOR="emacsclient"
