# -----
# utils
# -----

conf_dir = ~/.conf
user = $$USER
link_dotfile = @ln -sf $(conf_dir)/dotfiles/$(1) ~/$(1)
pkg_path = ~/Library/Application\ Support/Sublime\ Text.app/Packages

# -----
# tasks
# -----

default: install

all: install dotfiles osx bins apps npm gems sublime vim git adium desktop screensaver

warning:
	@printf "This will overwrite existing settings. Are you sure? (y/n) "; \
	read reply; \
	if [[ ! $$reply =~ ^[Yy]$$ ]]; then \
		exit 1;\
	fi;

install:
	@rsync -av --no-perms . $(conf_dir) &> /dev/null
	@echo "installed"

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

cask: brew
	@if ! brew tap | grep -q "phinze/cask"; then \
		brew tap phinze/cask; \
		brew install brew-cask; \
	fi;
	@brew tap | grep -q "caskroom/versions" || brew tap caskroom/versions

apps: cask
	@bash scripts/apps.sh
	# TODO: key bindings for totalterminal and alfred
	# totalterminal in com.apple.Terminal.plist / TotalTerminalShortcuts

node: cask
	@-if brew cask list | grep -q "node"; then \
		brew upgrade node; \
	else \
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
	@rbenv install 2.1.0

	# setting latest ruby as default
	@rbenv rehash
	@rbenv global 2.1.0

gems: ruby
	# making sure rdoc and ri are not installed with gems
	@echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc

	# installing gems
	sh scripts/gems.sh

pow: ruby
	curl get.pow.cx | sh

sublime: cask warning
	# installing sublime text if necessary
	@if ls /Applications/ | grep -q "Sublime Text.app"; then \
		brew cask install sublime-text3; \
		ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sub'; \
	fi

	# installing/updating package control
	cd $(pkg_path)/../Installed\ Packages
	curl -O https://sublime.wbond.net/Package%20Control.sublime-package
	cd -

	# copying package control packages
	cp sublime/* $(pkg_path)/User/

	# restarting sublime text
	killall Sublime\ Text

git: install warning brew
	# installing/updating git
	@-if @command -v git >/dev/null 2>&1; then \
		brew upgrade git; \
	else \
		brew install git; \
	fi

	# linking dotfiles
	$(call link_dotfile,.git-completion)
	$(call link_dotfile,.git-prompt)
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

	# TODO: generate ssh key if necessary

vim: install
	# linking dotfiles
	$(call link_dotfile,.vim)
	$(call link_dotfile,.vimrc)

adium:
	# TODO: implement this

desktop: warning
	@cp destkop/bg.jpg $(conf_dir)/desktop/bg.jpg
	@defaults write com.apple.desktop Background '{default = {ImageFilePath = "$(conf_dir)/desktop/bg.jpg"; };}'

screensaver: warning
	@cd /tmp
	@curl -O http://uglyapps.co.uk/nibbble/nibbble.1.2.zip
	@unzip nibbble.1.2.zip -d /Users/$(user)/Library/Screen\ Savers
	@cd -
	@defaults -currentHost write com.apple.screensaver { CleanExit = YES; PrefsVersion = 100; idleTime = 1200; moduleDict = { moduleName = Nibbble; path = "/Users/$(user)/Library/Screen Savers/Nibbble.saver"; type = 0; }; showClock = 0; }

# TODO: open a "finished" page with any additional instructions
# TODO: warnings, backups, and uninstalls?
