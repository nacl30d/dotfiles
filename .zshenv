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

path=(
    /opt/homebrew/bin(N-/)
    /opt/homebrew/sbin(N-/)
    /usr/local/opt/gnu-sed/libexec/gnubin(N-/)
    /usr/local/opt/grep/libexec/gnubin(N-/)
    /usr/local/opt/coreutils/libexec/gnubin(N-/)
    /usr/local/opt/findutils/libexec/gnubin(N-/)
    /usr/local/opt/curl/bin(N-/)
    /usr/local/opt/sqlite/bin(N-/)
    /usr/local/opt/nss/bin(N-/)
    /usr/local/opt/qt/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /usr/local/MacGPG2/bin(N-/)
    /Library/TeX/texbin(N-/)
    /usr/bin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    $HOME/bin(N-/)
    $HOME/.nodenv/shims(N-/)
    $HOME/.local/bin(N-/)
)
export LDFLAGS="-L/usr/local/opt/curl/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/nss/lib -L/usr/local/opt/qt/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/nss/include -I/usr/local/opt/qt/include"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/nss/lib/pkgconfig"

export HUGO_NEWCONTENTEDITOR="emacs"
export EDITOR="emacs"

