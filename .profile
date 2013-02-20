# Config Notes
# Dependencies: rbenv, >= ruby 1.9.3, pow, powder, git, git_completion, grc
 
# path: 
PS1='\[\e[0;31m\]⚡\[\e[m\] \[\e[0;30m\]${PWD##*/}\[\e[39m\] \[\e[0;33m\]$(__git_ps1 "(%s) ")\[\e[m\]'
 
# pretty colors (brew install grc)
source "`brew --prefix grc`/etc/grc.bashrc"
 
# general and rails
alias ll="ls -lahG"
alias reload="source ~/.profile"
alias profile="sub ~/.profile"
alias p="echo ''; cd ~/Projects; ls -c1; echo '';"
alias up="cd .."
alias desktop="cd ~/Desktop"
alias gen="rails g"
alias migrate="rake db:migrate"
alias seed="rake db:seed"
alias img="open app/assets/images"
alias be="bundle exec"
 
# handy git shortcuts and hacks
source ~/.git-completion.sh
source ~/.git-prompt.sh

alias go="git checkout"
alias godev="git checkout develop"
alias s="echo ''; git status -sb; echo ''"
alias stage="git add ."
alias c="fact; git commit -am"
alias got='git '
alias get='git '
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias branch="git branch"
alias mpush="git push origin master"
alias mpull="git pull origin master"
alias dpush="git push origin develop"
alias dpull="git pull origin develop"
alias hpush='git push heroku master'
alias amend="git commit --amend -m"
 
# powder shortcuts
alias r="powder"
alias opn="powder open"
alias log="powder applog"
 
# rbenv
export PATH="$HOME/.rbenv/bin:/usr/local/bin:$PATH"
eval "$(rbenv init -)"

# heroku
export PATH="/usr/local/heroku/bin:$PATH"
 
# =============================================
# Just for Fun
# =============================================
 
# random interesting face
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
