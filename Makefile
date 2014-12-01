# -----
# utils
# -----

conf_dir = ~/.conf
link_dotfile = ln -sf $(conf_dir)/dotfiles/$(1) ~/$(1)
sublime_pkg_path = ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
alfred_path = ~/Library/Application\ Support/Alfred\ 2
ruby_version = 2.1.5

success = echo "$$(tput setaf 2)$1$$(tput sgr 0)"
log = echo "$$(tput setaf 6)$1$$(tput sgr 0)"
danger = echo "$$(tput setaf 1)$1$$(tput sgr 0)"

# -----
# tasks
# -----

default: installz

all: installz dotfiles osx bins apps terminal alfred npm gems sublime vim git adium desktop screensaver

warning:
	@printf "This will overwrite existing settings. Are you sure? (y/n) "; \
	read reply; \
	if [[ ! $$reply =~ ^[Yy]$$ ]]; then \
		exit 1;\
	fi;

installz:
	@if ! [ -e /usr/local/bin/conf ]; then \
		sudo mkdir -p /usr/local/bin; \
		sudo chown -R $$USER /usr/local; \
		rsync -av --no-perms . $(conf_dir) &> /dev/null; \
		ln -sf $(conf_dir)/conf /usr/local/bin/conf; \
		$(call success,installed!); \
	fi

dotfiles: installz warning
	@echo "creating .bashrc"
	$(call link_dotfile,.bashrc)
	@echo "creating .bash_profile"
	$(call link_dotfile,.bash_profile)
	@echo "creating .profile"
	$(call link_dotfile,.profile)
	@echo "creating .hushlogin"
	$(call link_dotfile,.hushlogin)
	@echo "creating .z"
	$(call link_dotfile,.z.sh)
	@source ~/.profile

osx: installz warning
	@sh scripts/osx.sh

brew:
	@command -v brew >/dev/null 2>&1 || ruby -e "$$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/installz)"
	brew update

bins: brew
	@bash scripts/bins.sh

cask: brew git
	@if ! brew tap | grep -q "cask"; then \
		echo "# tapping cask"; \
		brew tap phinze/cask; \
		brew install brew-cask; \
	fi

	@if ! brew tap | grep -q "caskroom/versions"; then \
		echo "# tapping caskroom/versions"; \
		brew tap caskroom/versions; \
	fi

apps: cask
	@bash scripts/apps.sh

terminal: warning cask
	@if ! [ -d /opt/homebrew-cask/Caskroom/totalterminal ]; then \
		echo "# installing totalterminal"; \
		brew cask install totalterminal; \
	fi

	# installing terminal preferences
	# TODO: this is not working at the moment for some reason
	@cp preferences/terminal/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist

alfred: warning cask
	@if ! [ -d /Applications/Alfred\ 2.app ] && ! [ -d /opt/homebrew-cask/Caskroom/alfred ]; then \
		echo "# installing alfred"; \
		brew cask install alfred; \
	fi;

	# installing alfred preferences
	@open /opt/homebrew-cask/Caskroom/alfred/*/Alfred*.app
	@killall Alfred\ 2
	@cp -r preferences/alfred/Alfred.alfredpreferences/ $(alfred_path)/Alfred.alfredpreferences/

	# setting up powerpack license
	@echo "please enter your alfred license keys:"
	@printf "email: "; \
	read email; \
	printf "license code: "; \
	read code; \
	cp preferences/alfred/license-template.plist $(alfred_path)/license.plist; \
	/usr/libexec/PlistBuddy -c "Set :code $$code" $(alfred_path)/license.plist; \
	/usr/libexec/PlistBuddy -c "Set :email $$email" $(alfred_path)/license.plist

node: cask
	@if ! brew cask list | grep -q "node$$"; then \
		echo "# installing node"; \
		brew cask install node; \
	fi

npm: node
	@sudo chown -R $$USER /usr/local/lib
	@bash scripts/npm.sh

ruby: brew
	@if ! ruby -v | grep -q $(ruby_version); then \
		echo "# installing rbenv and ruby-build"; \
		brew install rbenv ruby-build; \

		echo "# linking dotfiles"; \
		$(call link_dotfile,.profile-ruby); \
		echo "source ~/.profile-ruby" >> ~/.profile; \

		echo "# installing latest version of ruby"; \
		rbenv install $(ruby_version); \

		echo "# setting latest ruby as default"; \
		rbenv rehash; \
		rbenv global $(ruby_version); \
	fi

gems: ruby
	# making sure rdoc and ri are not installed with gems
	@echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc

	# installing gems
	sh scripts/gems.sh

pow: ruby
	# installing pow
	curl get.pow.cx | sh

sublime: cask warning
	@if ! brew cask list | grep -q "sublime"; then \
		echo "# installing sublime text"; \
		brew cask install sublime-text3; \
		ln -s /opt/homebrew-cask/Caskroom/sublime-text3/*/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sub; \
	fi

	# installing/updating package control
	@open /opt/homebrew-cask/Caskroom/sublime-text3/*/Sublime\ Text.app
	@killall Sublime\ Text
	(cd $(sublime_pkg_path)/../Installed\ Packages && curl -O https://sublime.wbond.net/Package\ Control.sublime-package)

	# copying package control settings
	@cp preferences/sublime/* $(sublime_pkg_path)/User/

	# NOTE: When you first open sublime text, it will display a few error messages and pop up a text document with release notes. During this time, it is downloading packages. Just click "ok" on the error boxes and wait for a minute or two while the dowloads complete, then restart the editor and everything will be ready to roll.

git: install warning brew
	@if ! brew list | grep -q "git"; then \
		echo "# installing git"; \
		brew install git; \
	fi

	@if ! [ -e ~/.git-completion.sh ]; then \
		echo "# linking dotfiles"; \
		$(call link_dotfile,.git-completion.sh); \
		$(call link_dotfile,.git-prompt.sh); \
		$(call link_dotfile,.profile-git); \
		echo "source ~/.profile-git" >> ~/.profile; \
		echo "# configuring git"; \
		echo "please enter the following values for git configuration:"; \
		printf "name: "; \
		read name; \
		printf "email: "; \
		read email; \
		git config --global user.name "$$name"; \
		git config --global user.email $$email; \
		echo "# setting up credential helper"; \
		curl -s -O https://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain; \
		chmod u+x git-credential-osxkeychain; \
		sudo mv git-credential-osxkeychain "$$(dirname $$(which git))/git-credential-osxkeychain"; \
		git config --global credential.helper osxkeychain; \
		source ~/.profile; \
	fi

vim: installz
	# linking dotfiles
	$(call link_dotfile,.vim)
	$(call link_dotfile,.vimrc)

desktop: warning
	@osascript -e "tell application \"System Events\" to set picture of every desktop to \"$(conf_dir)/desktop/bg.jpg\""

screensaver: warning
	# downloading nibbble
	@curl -O /tmp/nibbble.zip http://uglyapps.co.uk/nibbble/nibbble.1.2.zip

	# moving it to screen savers
	@unzip /tmp/nibbble.1.2.zip -d ~/Library/Screen\ Savers/

	# setting screen saver preferences
	@defaults write $(find ~/Library/Preferences/ByHost/ -name com.apple.screensaver.*.plist) moduleDict -dict moduleName -string Nibbble path -string "$(eval echo ~)/Library/Screen Savers/Nibbble.saver"
