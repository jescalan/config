Configuration
-------------

There are a lot of things I need to configure when on a new computer, and I find myself doing this frequently. This is a tool for setting everything up the way I like it, and hopefully a base for you to set up things how you like them too, at very least.

### Installation

This setup is intended to work only on OSX, and has been tested with OSX Mavericks and up. If you are not running OSX or are running an old version, things _might_ not work, so be careful. Also, upgrade your OS. If you are on another OS, I would welcome patches or forks to make this work cross-OS, but I'm not in place where I can sink significant amounts of time into making this happen myself, so as far as I know, this repo will remain OSX-only.

Installing in full will replace settings for your terminal, sublime text, adium, a number of osx system settings, and your desktop background, and will install a number of apps and binaries. If you don't want some of these things to happen, it might be better to back your stuff up or manually install individual sections, which is described below. For any sections that will overwrite settings of any sort, you will be warned and given a chance to opt out.

To get started, clone this repo down, `cd` into it, and run `make`. This will get everything set up but not actually change your system or overwrite anything at all. For that part, keep reading.

### Usage

This tool has been made very specifically to be modular, so that you can choose and install just the pieces you want if you don't want everything. Everyone has different config preferences, and while I would of course understand if you chose to copy all of mine exactly, since they are the best, I understand that you might not want to. If you don't, you have two choices:

1. You like my configuration for some things, but not everything. You should just install what you want.
2. You like my configuration for some things or everything, but want to make some changes to fit your tastes. You should fork this repo, make the changes, and configure it to exactly your liking.

Below, I'll list out each of the install tools, and what they do. This can of course also be found in the source if you'd like mor details, but **the source is not documentation** so I don't expect anyone to look there, and no developer ever should. Document your code!

#### Dotfiles

This task will copy over a nice set of dotfiles for configuring bash preferences. It will overwrite `.bashrc`, `.bash_profile`, `.profile`, and `.gitconfig` (make sure to back these up if you already have them configured). It also links in a couple utilities for git and the command line that are loaded via the bash profile.

The real guts of this task are in [.profile](dotfiles/.profile), which is commented and you should feel free to scan through for specifics. Overall, it gives you a nice pretty prompt including info about git if you're using it, adds a bunch of git shortcuts for common tasks, a couple aliases for rails and powder, and a number of general and fun utility aliases and functions.

#### OSX

**Install:** `conf install osx`

This task tweaks a bunch of configuration in OSX. More specifically, it will:

- disable press-and-hold keys and make the key repeat rate as high as possiblw
- illuminate the keyboard in low light but turn off after 5 mins of inactivity
- require a password after sleep or screen saver
- show icons for hard drives and other media on desktop
- disable warning when changing file extensions
- enable airdrop whenever possible
- auto hide/show the dock
- make dock icons of hidden applications translucent
- very quick mouse/trackpad speed (try it, you'll adjust quickly)
- disable app installation restrictions
- use google DNS
- hot corners:
  - top right > all windows
  - top left > screen saver
  - bottom left > show desktop

If there are any other optimizations you have made to OSX and enjoyed feel free to open an issue and suggest it!

#### Binaries

**Install:** `conf install bins`

As developers (I assume the main audience), there are a number of important command line utilities that are useful to have installed. This task uses homebrew to get a few essentials up and running. Specifically:

- coreutils
- findutils
- libxml2
- libxslt
- openssl
- readline
- git
- tig
- grc
- tmux
- postgres
- mysql
- redis
- mongodb
- imagemagick
- wget
- cowsay
- ack
- nginx

#### Apps

**Install:** `conf install apps`

Thanks to the wonders of [homebrew cask](#), native app installation can now be automated. This task installs the following apps:

- adium
- alfred
- appzapper
- caffeine
- cloudapp
- cloudup
- daisydisk
- dash
- flux
- fantastical
- ffmpegx
- google-chrome
- imagealpha
- imageoptim
- node-webkit
- sequel-pro
- silverlight
- sketch
- skype
- slack
- spotify
- totalterminal
- vlc

#### Node

**Install:** `conf install node`

Pretty straightforward, just installs [nodejs](http://nodejs.org), most recent version.

#### NPM Packages

**Install:** `conf install npm`

Will automatically install node if not already installed, then put in some useful global npm packages, specifically:

- coffee-script
- mocha
- docco
- gulp
- roots
- sprout
- svgo
- express
- stylus
- grunt-cli
- ship

#### Ruby

**Install:** `conf install ruby`

Uses [rbenv](#) to install the latest stable release of ruby. This one takes a few minutes because it is super slow installing ruby, so be prepared to wait. But it will work.

#### Gems

**Install:** `conf install gems`

Will install ruby if not already present, then put in some useful ruby gems, specifically:

- bundler
- rails
- powder

#### Sublime

**Install:** `conf install sublime`

Will install sublime text 3 and set up the preferences the way I like them. First, it installs package control, then put in the following packages:

- AdvancedNewFile
- Alignment
- BracketHighlighter
- CoffeeScript
- DocBlockr
- Emmet
- GitGutter
- GotoRecent
- Haml
- HexViewer
- HTML5
- Http Requester
- Jade
- jQuery Snippets pack
- JsMinifier
- Marked.app Menu
- Nodejs
- Package Control
- Ruby Slim
- SCSS
- Stylus
- SublimeBlockCursor
- Sublimipsum
- Theme - Spacegray

And adjust the user preferences to [these](sublime/Preferences.sublime-settings).

#### Vim

**Install:** `conf install vim`

Sets up vim preferneces to always have syntax highlighting on, sets the color theme to [tomorrow-night](#), and makes indents 2 spaces. Nothing too crazy, I don't use vim as often as sublime for local editing.

#### Git

**Install:** `conf install git`

Installs the latest version of git and prompts you to set it up with your credentials and ssh key.

#### Adium

**Install:** `conf install adium`

Installs [Adium](#) if not already present, reskins it to look awesome, and adds a few useful extensions.

#### Destkop

**Install:** `conf install desktop`

Sets your desktop background to my current desktop of choice ; )

#### Screen Saver

Sets your screen saver to the wonderful [nibbble](#) for design inspiration.

**Install:** `conf install screensaver`

### Miscellaneous

- Many thanks to Mathiyas Bynens' [dotfiles](#) for inspiration and a number of nice utilities I borrowed : )
- License can be [found here](LICENSE.md)
- Info on contributing and pull requests can be [found here](contributing.md)
