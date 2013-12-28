install: copy dotfiles osx bins apps npm gems sublime git desktop screensaver

warning:
	read -p "This will overwrite existing settings. Are you sure? (y/n) " -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit 1
	fi

copy:
	cp -r . ~/.conf
	cp -r ./.* ~/.conf
	cd ~/.conf

dotfiles: warning
	function link_dotfile(){ ln -sf ~/.conf/"${@}" ~/"${@}" }
	link_dotfile .bashrc
	link_dotfile .bash_profile
	link_dotfile .profile
	link_dotfile .gitconfig
	link_dotfile .hushlogin
	link_dotfile .vimrc
	link_dotfile .git-completion
	link_dotfile .git-prompt

osx: warning
	sh scripts/osx.sh

brew:
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

bins: brew
	sh scripts/bins.sh

cask: brew
	brew tap phinze/homebrew-cask
	brew install brew-cask
	brew tap caskroom/versions # beta/alt versions

apps: cask
	sh scripts/apps.sh
	# TODO: key bindings for totalterminal and alfred

node: cask
	brew cask install node

npm: node
	sh scripts/npm.sh

ruby: brew
	brew install rbenv ruby-build

	# TODO: check for bash_profile and bashrc here too
	if grep -q 'eval "$(rbenv init -)"' ~/.profile; then
		echo '\neval "$(rbenv init -)"' >> ~/.profile
	fi

	rbenv install 2.0.0-p353
	rbenv rehash
	rbenv global 2.0.0-p353

gems: ruby
	sh scripts/gems.sh

pow: ruby
	curl get.pow.cx | sh

sublime: cask warning
	# install sublime text if necessary
	if ls /Applications/ | grep -q "Sublime Text.app"; then
		brew cask install sublime-text3
		ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sub
	fi

	pkg_path = ~/Library/Application\ Support/Sublime\ Text.app/Packages

	# install/update package control
	cd $pkg_path/../Installed\ Packages
	curl -O https://sublime.wbond.net/Package%20Control.sublime-package
	cd -

	# copy package control packages
	cp sublime/* $pkg_path/User/

	# restart sublime text
	killall Sublime\ Text

git: brew
	brew install git

desktop: warning
	cp destkop/bg.jpg ~/.conf/desktop/bg.jpg
	defaults write com.apple.desktop Background '{default = {ImageFilePath = "~/.config/desktop/bg.jpg"; };}'

screensaver: warning
	cd /tmp
	curl -O http://uglyapps.co.uk/nibbble/nibbble.1.2.zip
	unzip nibbble.1.2.zip -d /Users/`echo $USER`/Library/Screen\ Savers
	cd -
	defaults -currentHost read com.apple.screensaver { CleanExit = YES; PrefsVersion = 100; idleTime = 1200; moduleDict = { moduleName = Nibbble; path = "/Users/`echo $USER`/Library/Screen Savers/Nibbble.saver"; type = 0; }; showClock = 0; }

# TODO: open a "finished" page with any additional instructions
# TODO: warnings, backups, and uninstalls?
