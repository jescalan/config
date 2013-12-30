default: install

all: install dotfiles osx bins apps npm gems sublime vim git adium desktop screensaver

warning:
	@printf "This will overwrite existing settings. Are you sure? (y/n) "; \
	read reply; \
	if [[ ! $$reply =~ ^[Yy]$$ ]]; then \
		exit 1;\
	fi;

install:
	@printf "installing... "
	@rsync -av --no-perms . ~/.conf &> /dev/null
	@echo "done!"

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
	# totalterminal in com.apple.Terminal.plist / TotalTerminalShortcuts

node: cask
	brew cask install node

npm: node
	sh scripts/npm.sh

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
	echo -e "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" >> ~/.gemrc
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
	# TODO: set up email, ssh keys, etc

vim: install
	ln -sf ~/.conf/dotfiles/.vim ~/.vim
	ln -sf ~/.conf/dotfiles/.vimrc ~/.vimrc

adium:
	# TODO: implement this

desktop: warning
	cp destkop/bg.jpg ~/.conf/desktop/bg.jpg
	defaults write com.apple.desktop Background '{default = {ImageFilePath = "~/.config/desktop/bg.jpg"; };}'

screensaver: warning
	cd /tmp
	curl -O http://uglyapps.co.uk/nibbble/nibbble.1.2.zip
	unzip nibbble.1.2.zip -d /Users/`echo $USER`/Library/Screen\ Savers
	cd -
	defaults -currentHost write com.apple.screensaver { CleanExit = YES; PrefsVersion = 100; idleTime = 1200; moduleDict = { moduleName = Nibbble; path = "/Users/`echo $USER`/Library/Screen Savers/Nibbble.saver"; type = 0; }; showClock = 0; }

# TODO: open a "finished" page with any additional instructions
# TODO: warnings, backups, and uninstalls?
