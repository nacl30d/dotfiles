#! /usr/bin/env bash

set -Ceu

. ${DOTPATH}/etc/lib/vital.sh

MOZCPATH="${DOTPATH}/etc/mozc"; export $MOZCPATH

: "check pre-requirements" && {
    if ! has git; then
        echo 'error: require: git'
        exit 1
    fi

    if ! has ninja; then
        if ! has brew; then
            echo 'error: require: brew'
            exit 1
        fi

        echo 'Install ninja'
        brew update
        brew install ninja
    fi
}

: "Install mozc" && {
    echo 'Download mozc source...'
    git clone https://github.com/google/mozc.git ${MOZCPATH} -b master --single-branch --recursive

    cd ${MOZCPATH}/src/

    echo 'Modify mozc source'
    patch -u mozc_build.py < ${DOTPATH}/etc/init/osx/mozc_build.patch
    
    echo 'Build mozc...'
    SW_VER="$(sw_vers | grep ProductVersion | awk '{print $2}')"; export $SW_VER
    SDK_VER="$(ls /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs | grep -E "[0-9]+\.sdk$" | sed -E 's/^MacOSX([0-9\.]+)\.sdk$/\1/')"; export $SDK_VER
    GYP_DEFINES="mac_sdk=${SDK_VER}mac_deployment_target=${SW_VER}" python build_mozc.py gyp --noqt

    python build_mozc.py build -c Release mac/mac.gyp:GoogleJapaneseInput mac/mac.gyp:gen_launchd_confs unix/emacs/emacs.gyp:mozc_emacs_helper

    echo 'Deploy mozc...'
    sudo cp -r out_mac/Release/Mozc.app /Library/Input\ Methods/
    sudo cp out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents
    sudo cp out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents
}

echo 'Done: You can use mozc on emacs!'

