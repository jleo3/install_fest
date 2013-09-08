#!/usr/bin

# This script is intended to uninstall everything that install_fest.sh installs.

uninstall_homebrew() {
  brew install git
  brew update
  cd `brew --prefix`
  git checkout master
  git ls-files -z | pbcopy
  rm -rf Cellar
  bin/brew prune
  pbpaste | xargs -0 rm
  rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions 
  test -d Library/LinkedKegs && rm -r Library/LinkedKegs
  rmdir -p bin Library share/man/man1 2> /dev/null
  rm -rf .git
  rm -rf ~/Library/Caches/Homebrew
  rm -rf ~/Library/Logs/Homebrew
  rm -rf /Library/Caches/Homebrew
}
  
OS=`lowercase \`uname\``

if [[ $OS == "darwin" ]]; then
  echo "removing Mac OS tools"

  uninstall_homebrew
  rvm implode
  gem uninstall rails
  

fi
