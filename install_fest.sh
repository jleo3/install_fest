#!/bin/bash

set -e

lowercase(){
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

install_mac_tools() {
  # Do we have to install mac tools?
  XCODE=`xcode-select --version | grep -i 'not found' || true`
  if [[ $? -eq 1 ]]; then
    `xcode-select --install`
  else
    echo "xcode already installed"
    return
  fi
}

install_homebrew() {
  echo "Installing Homebrew..."
  sudo ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
}

update_homebrew() {
  echo "Updating Homebrew..."
  brew update
  echo "...done"
}

brew_install_git() {
  echo "Installing git..."
  brew install git
  config_git
  echo "...done"
}

update_rubygems() {
  echo "Updating rubygems to latest version..."
  gem update --system
  echo "...done"
}

install_bundler() {
  echo "Installing bundler..."
  gem install bundler
  echo "...done"
}

install_ruby() {
  echo "Installing Ruby..."
  curl -L https://get.rvm.io | bash -s stable --ruby
  source $HOME/.rvm/scripts/rvm
  rvm use 2.1.0 --default
  echo "...done"
}

install_rails() {
  echo "Installing rails..."
  gem install -v 4.0.4 rails
  echo "...done"
}

install_sublime_text_mac() {
  echo "Downloading and installing SublimeText"
  cd /tmp && curl http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg -O
  sudo hdiutil attach /tmp/Sublime\ Text\ 2.0.2.dmg
  sudo installer -pkg /Volumes/Sublime\ Text\ 2.0.2/Sublime\ Text\ 2.0.2.pkg -target /Applications
  sudo hdiutil detach /tmp/Sublime\ Text\ 2.0.2.dmg
  echo "...done"

  subl_to_path .bash_profile
}
  
install_sublime_text_linux() {
  echo "Downloading and installing SublimeText"
  cd /tmp && wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
  tar xjvf /tmp/Sublime\ Text\ 2.0.2.tar.bz2 -C $HOME/ga/lib
  echo "...done"

  subl_to_path .bashrc
}

subl_to_path() {
  echo "Adding Sublime Text to your PATH..."
  mv ~/ga/lib/Sublime\ Text\ 2/ ~/ga/lib/sublime_text
  mv ~/ga/lib/sublime_text/sublime_text ~/ga/lib/sublime_text/subl
  echo "PATH=$PATH:$HOME/ga/lib/sublime_text" >> ~/$1

  echo "...done"
}

check_install() {
  echo "Installation is complete. Check that everything works:"
  echo "  1. Open a new command line (don't use this one)."
  echo "  2. Type 'rvm -v'"
  echo "     - you should see version 1.0.0 or higher"
  echo "  3. Type 'ruby -v'"
  echo "     - you should see version 2.0.0"
  echo "  4. Type 'rails -v'"
  echo "     - you should see version 4.0.0"
  echo "  5. Type 'git config -l'"
  echo "     - you should see your username and email in the output"
  echo "  6. Type 'subl foo'"
  echo "     - Sublime Text editor should open up"
  echo ""
  echo "If everything worked then you are set for BEWD! Go forth and program!"
}

config_git() {
  echo "What is your GitHub username? (If you don't have one, now's a great time to come up with one!)"
  read username
  git config --global user.name "$username"

  echo "What is your GitHub email?" email
  read email
  git config --global user.email "$email"

  echo "OK, I've set up your git config"
}

OS=`lowercase \`uname\``
GA_LIB="$HOME/ga/lib"

echo "creating a directory for ga tools at ~/ga/lib"
mkdir -p $GA_LIB

if [[ $OS == "darwin" ]]; then
  echo "Mac OS X.. An aristocrat, eh?"

  install_mac_tools
  install_ruby
  update_rubygems
  install_homebrew
  update_homebrew
  brew_install_git
  install_bundler
  install_rails
  install_sublime_text_mac
  check_install
elif [[ $OS == "linux" ]]; then
  echo "Ah, classy operating system!"

  echo "Updating system..."
  sudo apt-get update
  echo "...done"

  echo "Installing curl..."
  sudo apt-get install -y curl
  echo "...done"

  install_ruby

  echo "Installing git..."
  sudo apt-get install -y build-essential git-core
  config_git
  echo "...done"

  update_rubygems
  install_bundler
  install_rails
  install_sublime_text_linux

  source $HOME/.bashrc
  check_install
  echo "You are set for BEWD! Go forth and program!"
fi
