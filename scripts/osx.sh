# disable press-and-hold-keys
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# auto illuminate keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# turn off keyboard light when not used for 5 min
defaults write com.apple.BezelServices kDimTime -int 300

# require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# terminal color theme
killall Terminal # don't change settings while terminal is open
open ~/.conf/terminal/jenius.terminal
sleep 1 # make sure theme is loaded
defaults write com.apple.Terminal "Default Window Settings" -string jenius
defaults write com.apple.Terminal "Default Window Settings" -string jenius

# quick mouse/trackpad movement
defaults write com.apple.trackpad.scaling -float 2.5
defaults write com.apple.mouse.scaling -float 2.5

# disable app install restrictions
spctl --master-disable

# use google dns
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# hot corners
# -----------

# top right corner -> show all windows
defaults write com.apple.dock wvous-tr-corner -int 3
defaults write com.apple.dock wvous-tr-modifier -int 0

# top left corner -> screen saver
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0

# bottom left corner -> show desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
