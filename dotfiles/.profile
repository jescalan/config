# Configuration
# (https://github.com/jenius/config)

# ------
# prompt
# ------

# TODO: backup __git_ps1 if git prompt is not installed
PS1='\[\e[0;31m\]⚡\[\e[m\] \[\e[0;30m\]${PWD##*/}\[\e[39m\] \[\e[0;33m\]$(__git_ps1 "(%s) ")\[\e[m\]'

# -------------
# general / fun
# -------------

source ~/.z.sh

alias ll="ls -lahG"
alias reload="exec $SHELL -l"
alias profile="vim ~/.profile"
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
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
alias ding='afplay /System/Library/Sounds/Glass.aiff'
alias fact="echo '------------------------------------------------------------';  curl -s randomfunfacts.com | LANG=C sed -n 's/.*<i>\(.*\)<\/i>.*/\1/p'; echo '------------------------------------------------------------'"

random_word() {
  resource=/usr/share/dict/words;
  lineNum=$(cat $resource | wc -l);
  cat -n $resource | grep -w $(jot -r 1 1 $lineNum) | cut -f2;
}

# ---------
# resources
# ---------

