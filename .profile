# Config Notes
# Dependencies: rbenv, >= ruby 1.9.3, pow, powder, git, git_completion

# prompt
PS1='\[\e[0;31m\]⚡\[\e[m\] \[\e[0;30m\]${PWD##*/}\[\e[39m\] \[\e[0;33m\]$(__git_ps1 "(%s) ")\[\e[m\]'

# git (http://git-scm.com/)
source ~/.git-completion.sh
source ~/.git-prompt.sh

alias co="git checkout"
alias s="echo ''; git status -sb; echo ''"
alias c="git commit"
alias cm="fact; git commit -am"
alias stage="git add ."
alias pullr="git pull -r"
alias push="git push"
alias ri="git rebase -i"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias branch="git branch"
alias amend="git commit --amend -m"

tag() { git tag -a $1 -m "$1" }

# powder (https://github.com/Rodreegez/powder)
alias r="powder"
alias opn="powder open"
alias log="powder applog"

# rails (http://rubyonrails.org)
alias migrate="rake db:migrate"
alias seed="rake db:seed"
alias img="open app/assets/images"
alias be="bundle exec"

# general
alias ll="ls -lahG"
alias reload="exec $SHELL -l"
alias profile="sub ~/.profile"
alias p="echo ''; cd ~/Sites; ls -c1; echo '';"
alias up="cd .."
alias back="cd -"
alias desktop="cd ~/Desktop"
alias server="python -m SimpleHTTPServer"
alias ios-sim="open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app/"
alias timesync="sudo ntpdate -u $(systemsetup -getnetworktimeserver|awk '{print $4}')"
alias nginx-restart="sudo nginx -s stop && sudo nginx"
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update --system; sudo gem update'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# rbenv
export PATH="$HOME/.rbenv/bin:/usr/local/bin:$PATH"
eval "$(rbenv init -)"

# =============================================
# Just for Fun
# =============================================

# random interesting fact
alias fact="echo '------------------------------------------------------------';  curl -s randomfunfacts.com | LANG=C sed -n 's/.*<i>\(.*\)<\/i>.*/\1/p'; echo '------------------------------------------------------------'"

# play a ding
alias ding='afplay /System/Library/Sounds/Glass.aiff'

# get a random word from the system dictionary.
random_word() {
  resource=/usr/share/dict/words;
  lineNum=$(cat $resource | wc -l);
  cat -n $resource | grep -w $(jot -r 1 1 $lineNum) | cut -f2;
}

# a git url shortener
gurl() {
  if [ "$2" ]
  then
    url="url=$1 -F $2";
  else
    url="url=$1";
  fi
  curl -i http://git.io -F $url
}

# stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
