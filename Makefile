default: install

all: install dotfiles osx bins apps npm gems sublime vim git adium desktop screensaver

warning:
	@printf "This will overwrite existing settings. Are you sure? (y/n) "; \
	read reply; \
	if [[ ! $$reply =~ ^[Yy]$$ ]]; then \
		exit 1;\
	fi;

install:
	@rsync -av --no-perms . ~/.conf &> /dev/null
	@echo "installed"

link_dotfile = @ln -sf ~/.conf/dotfiles/$(1) ~/$(1)

dotfiles: install warning
	@echo "creating .bashrc"
	$(call link_dotfile,.bashrc)
	@echo "creating .bash_profile"
	$(call link_dotfile,.bash_profile)
	@echo "creating .profile"
	$(call link_dotfile,.profile)
	@echo "creating .gitconfig"
	$(call link_dotfile,.gitconfig)
	@echo "creating .hushlogin"
	$(call link_dotfile,.hushlogin)
	@echo "creating .git-completion"
	$(call link_dotfile,.git-completion.sh)
	@echo "creating .git-prompt"
	$(call link_dotfile,.git-prompt.sh)
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
	brew install rbenv ruby-build

	# TODO: check for bash_profile and bashrc here too
	# TODO: also include path and comment here
	if grep -q 'eval "$(rbenv init -)"' ~/.profile; then
		echo -e '\neval "$(rbenv init -)"' >> ~/.profile
	fi

	rbenv install 2.0.0-p353
	rbenv rehash
	rbenv global 2.0.0-p353

gems: ruby
	@echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc
	sh scripts/gems.sh

pow: ruby
	curl get.pow.cx | sh

pkg_path = ~/Library/Application\ Support/Sublime\ Text.app/Packages
sublime: cask warning
	# install sublime text if necessary
	@if ls /Applications/ | grep -q "Sublime Text.app"; then \
		brew cask install sublime-text3; \
		ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sub'; \
	fi

	# install/update package control
	cd $(pkg_path)/../Installed\ Packages
	curl -O https://sublime.wbond.net/Package%20Control.sublime-package
	cd -

	# copy package control packages
	cp sublime/* $(pkg_path)/User/

	# restart sublime text
	killall Sublime\ Text

git: install warning brew
	# installing / updating git...
	@-if @command -v git >/dev/null 2>&1; then \
		brew upgrade git; \
	else \
		brew install git; \
	fi

	# linking gitconfig...
	@ln -sf ~/.conf/dotfiles/.gitconfig ~/.gitconfig

	# configure git
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
	ln -sf ~/.conf/dotfiles/.vim ~/.vim
	ln -sf ~/.conf/dotfiles/.vimrc ~/.vimrc

adium:
	# TODO: implement this

desktop: warning
	@cp destkop/bg.jpg ~/.conf/desktop/bg.jpg
	@defaults write com.apple.desktop Background '{default = {ImageFilePath = "~/.config/desktop/bg.jpg"; };}'

screensaver: warning
	@cd /tmp
	@curl -O http://uglyapps.co.uk/nibbble/nibbble.1.2.zip
	@unzip nibbble.1.2.zip -d /Users/`echo $USER`/Library/Screen\ Savers
	@cd -
	@defaults -currentHost write com.apple.screensaver { CleanExit = YES; PrefsVersion = 100; idleTime = 1200; moduleDict = { moduleName = Nibbble; path = "/Users/`echo $USER`/Library/Screen Savers/Nibbble.saver"; type = 0; }; showClock = 0; }

# TODO: open a "finished" page with any additional instructions
# TODO: warnings, backups, and uninstalls?
