# -----
# utils
# -----

conf_dir = ~/.conf
link_dotfile = @ln -sf $(conf_dir)/dotfiles/$(1) ~/$(1)
sublime_pkg_path = ~/Library/Application\ Support/Sublime\ Text.app/Packages

# -----
# tasks
# -----

default: install

all: install dotfiles osx bins apps terminal alfred npm gems sublime vim git adium desktop screensaver

warning:
	@printf "This will overwrite existing settings. Are you sure? (y/n) "; \
	read reply; \
	if [[ ! $$reply =~ ^[Yy]$$ ]]; then \
		exit 1;\
	fi;

install:
	# make this conditional based on presence of conf bin
	@sudo mkdir -p /usr/local/bin
	@sudo chown -R $$USER /usr/local
	@rsync -av --no-perms . $(conf_dir) &> /dev/null
	@ln -sf $(conf_dir)/conf /usr/local/bin/conf
	@/bin/echo "$$(tput setaf 2)installed!$$(tput sgr 0)"

dotfiles: install warning
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

osx: install warning
	@sh scripts/osx.sh

brew:
	@command -v brew >/dev/null 2>&1 || ruby -e "$$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
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
	# TODO: correct for cask path
	@if ! ls /Applications/ | grep -q "TotalTerminal.app"; then \
		echo "# installing totalterminal"; \
		brew cask install totalterminal; \
	fi
	
	# installing terminal preferences
	# TODO: this is not working at the moment for some reason
	@cp preferences/terminal/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist

alfred: warning cask
	
	@if ! [ -d /Applications/Alfred\ 2.app ] && ! [ -d /opt/homebrew-cask/Caskroom/alfred ]; then \
		echo "# installing alfred"; \
		cask install alfred; \
	fi;

	alfred_path = ~/Library/Application\ Support/Alfred\ 2
	
	# installing alfred preferences
	cp preferences/alfred/Alfred.alfredpreferences $(alfred_path)/Alfred.alfredpreferences

	@echo "please enter your alfred license keys:"
	@printf "email: "; \
	read email; \
	printf "license code: "; \
	read code; \

	# writing license file
	cp preferences/alfred/license-template.plist $(alfred_path)/license.plist
	/usr/libexec/PlistBuddy -c "Set :code $$code" $(alfred_path)/license.plist
	/usr/libexec/PlistBuddy -c "Set :email $$email" $(alfred_path)/license.plist

node: cask
	@if brew cask list | grep -q "node"; then \
		echo "# updating node"; \
		brew upgrade node; \
	else \
		echo "# installing node"; \
		brew cask install node; \
	fi


npm: node
	@bash scripts/npm.sh

ruby: brew
	# installing rbenv and ruby-build
	@brew install rbenv ruby-build

	# linking dotfiles
	$(call link_dotfile,.profile-ruby)
	@echo "source ~/.profile-ruby" >> ~/.profile

	# installing latest version of ruby
	@rbenv install 2.1.2

	# setting latest ruby as default
	@rbenv rehash
	@rbenv global 2.1.2

gems: ruby
	# making sure rdoc and ri are not installed with gems
	@echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc

	# installing gems
	sh scripts/gems.sh

pow: ruby
	# installing pow
	curl get.pow.cx | sh

sublime: cask warning
	# TODO: correct sublime text path for cask
	@if ls /Applications/ | grep -q "Sublime Text.app"; then \
		echo "# installing sublime text"; \
		brew cask install sublime-text3; \
		ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sub'; \
	fi

	# installing/updating package control
	cd $(sublime_pkg_path)/../Installed\ Packages
	curl -O https://sublime.wbond.net/Package%20Control.sublime-package
	cd -

	# copying package control packages
	cp preferences/sublime/* $(sublime_pkg_path)/User/

	# restarting sublime text
	killall Sublime\ Text

git: install warning brew
	@if ! brew list | grep -q "git"; then \
		echo "# installing git"; \
		brew install git; \
	fi

	# linking dotfiles
	$(call link_dotfile,.git-completion.sh)
	$(call link_dotfile,.git-prompt.sh)
	$(call link_dotfile,.profile-git)
	@echo "source ~/.profile-git" >> ~/.profile

	# configuring git
	@echo "please enter the following values for git configuration:"
	@printf "name: "; \
	read name; \
	printf "email: "; \
	read email; \
	git config --global user.name "$$name"; \
	git config --global user.email $$email;

	# setting up credential helper
	@curl -s -O https://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
	@chmod u+x git-credential-osxkeychain
	@sudo mv git-credential-osxkeychain "$$(dirname $$(which git))/git-credential-osxkeychain"
	@git config --global credential.helper osxkeychain

vim: install
	# linking dotfiles
	$(call link_dotfile,.vim)
	$(call link_dotfile,.vimrc)

desktop: warning
	@osascript -e "tell application \"System Events\" to set picture of every desktop to \"$(conf_dir)/desktop/bg.jpg\""

screensaver: warning
	# downloading nibbble
	@cd /tmp
	@curl -O http://uglyapps.co.uk/nibbble/nibbble.1.2.zip

	# moving it to screen savers
	@unzip nibbble.1.2.zip -d ~/Library/Screen\ Savers/
	@cd -

	# setting screen saver preferences
	screensaver_filename = $(find ~/Library/Preferences/ByHost/ -name com.apple.screensaver.*.plist)
	@defaults write screensaver_filename moduleDict -dict moduleName -string Nibbble path -string "$(eval echo ~)/Library/Screen Savers/Nibbble.saver"
