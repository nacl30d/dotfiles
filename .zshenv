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
    /Library/TeX/texbin(N-/)
    /usr/bin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
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

export LDFLAGS="-L/usr/local/opt/curl/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/nss/lib -L/usr/local/opt/qt/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/nss/include -I/usr/local/opt/qt/include"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/nss/lib/pkgconfig:$BREW_PREFIX/opt/libffi/lib/pkgconfig:$BREW_PREFIX/opt/zlib/lib/pkgconfig:$BREW_PREFIX/opt/expat/lib/pkgconfig:$BREW_PREFIX/opt/libxml2/lib/pkgconfig"

export EDITOR="emacsclient"
