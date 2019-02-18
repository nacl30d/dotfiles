#! /usr/bin/env bash

set -Ceu

if [ -z "$DOTPATH" ]; then
    echo'$DOTPATH not set' >&2
    exit 1
fi

. "$DOTPATH"/etc/lib/vital.sh

if has "emacs_mozc_helper"; then
    e_ok "emacs_mozc"
    exit 0
fi


MOZCPATH="${DOTPATH}/etc/mozc"

: "check pre-requirements" && {
    if ! has git; then
        die "require: git"
    fi

    if ! has ninja; then
        if ! has brew; then
            die 'require: brew'
        fi

        e_arrow 'Installing ninja'
        brew update
        brew install ninja

        if ! has ninja; then
            die "ninja: Faild to install."
    fi
}

: "Install mozc" && {
    e_arrow 'Downloading mozc source'
    git clone https://github.com/google/mozc.git ${MOZCPATH} -b master --single-branch --recursive

    cd ${MOZCPATH}/src/

    e_arrow 'Updating mozc source'
    patch -u build_mozc.py < ${DOTPATH}/etc/init/osx/build_mozc.patch
    
    e_arrow 'Building mozc'
    SW_VER="$(sw_vers | grep ProductVersion | awk '{print $2}')"
    SDK_VER="$(ls /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs | grep -E "[0-9]+\.sdk$" | sed -E 's/^MacOSX([0-9\.]+)\.sdk$/\1/')"
    GYP_DEFINES="mac_sdk=${SDK_VER} mac_deployment_target=${SW_VER}" python build_mozc.py gyp --noqt

    e_info "Please change build terget by your self. \n Select Deployment Target (your sdk ver) on `Interface Builder Document > Document Editing > Builds for`"
    open -W -aa /Applications/Xcode.app ./third_party/breakpad/src/client/mac/sender/Breakpad.xib
    
    python build_mozc.py build -c Release mac/mac.gyp:GoogleJapaneseInput mac/mac.gyp:gen_launchd_confs unix/emacs/emacs.gyp:mozc_emacs_helper

    e_arrow 'Installing mozc'
    sudo cp -r out_mac/Release/Mozc.app /Library/Input\ Methods/
    sudo cp out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents
    sudo cp out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents
}

e_success "emacs_mozc: Installed successfully!"
exit 0

