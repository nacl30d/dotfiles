setopt no_global_rcs
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
path=(
    /usr/local/opt/grep/libexec/gnubin(N-/)
    /usr/local/opt/coreutils/libexec/gnubin(N-/)
    /usr/local/opt/curl/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /Library/TeX/texbin(N-/)
    /usr/bin(N-/)
    /bin(N-/)
    /usr/sbin(N-/)
    /sbin(N-/)
    /opt/X11/bin(N-/)
    $HOME/bin(N-/)
)
export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"

