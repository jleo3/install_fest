#!/usr/bin

# This script is intended to uninstall everything that install_fest.sh installs.

uninstall_homebrew() {
  cd `brew --prefix`
  rm -rf Cellar
  brew prune
  rm `git ls-files`
  rm -r Library/Homewbrew\ Library/Aliases\ Library/Formula\ Library/Contributions
  rm -rf .git
  rm -rf ~/Library/Caches/Homebrew
}

OS=`lowercase \`uname\``

if [[ $OS == "darwin" ]]; then
  echo "removing Mac OS tools"

  rvm implode

  uninstall_homebrew

fi
