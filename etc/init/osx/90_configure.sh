#! /usr/bin/env bash

set -Cue

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

if ! is_osx; then
    die "This script is only supported with osx."
fi

if ! has "defaults"; then
    e_warning "\`defaults\` not found. Nothing to do."
    exit 0
fi

e_arrow_blue "Setting up general configures"
defaults write -g AppleLanguages '("en-JP", "ja-JP")'
defaults write -g AppleShowScrollBars -string "WhenScrolling"
defaults write -g AppleShowAllExtensions -bool true

e_arrow_blue "Setting up keyboard"
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnables -bool false
defaults write -g com.apple.keyboard.fnState -bool true
defaults write -g InitialKeyRepeat -int 15

e_arrow_blue "Setting up trackpad"
defaults write -g com.apple.trackpad.forceClick -bool false
defaults write -g com.apple.trackpad.scaling -int 2
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2

e_arrow_blue "Setting up dock"
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock titlesize -int 64

e_arrow_blue "Setting up hot-corners"
defaults write com.apple.dock wvous-bl-corner -int 5 # screen saver
defaults write com.apple.dock wvous-bl-modifire -int 0
defaults write com.apple.dock wvous-br-corner -int 10 # display sleep
defaults write com.apple.dock wvous-br-modifire -int 0
defaults write com.apple.dock wvous-tr-corner -int 10 # display sleep
defaults write com.apple.dock wvous-tr-modifire -int 0

e_arrow_blue "Setting up finder"
defaults write com.apple.finer ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finer ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finer ShowMountedServersOnDesktop -bool true
defaults write com.apple.finer ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finer ShowStatusBar -bool true
defaults write com.apple.finer ShowPathbar -bool true
killall Finder

e_arrow_blue "Setting up various configures"
defaults write com.apple.screencapture location -string "$HOME/Box Sync/ScreenCapture"
defaults write com.apple.screencapture name -string ""
killall SystemUIServer

e_success "configures: successfully!"
exit 0

