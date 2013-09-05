#!/bin/bash

set -e

lowercase(){
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

install_mac_tools() {
  VERSION=`sw_vers -productVersion`
  SNOW_LEOPARD=10.6
  LION=10.7
  MOUNTAIN_LION=10.8
  GCC_6="GCC-10.6.pkg"
  GCC_7="GCC_10.7.pkg"

  cd /tmp/
  if [[ $VERSION == *"$SNOW_LEOPARD"* ]]; then
    echo "version is 10.6"
    curl -L https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg -O
    sudo installer -pkg /tmp/$GCC_6 -target $GA_LIB
  elif [[ $VERSION == *"$LION"* || $VERSION == *"$MOUNTAIN_LION"* ]]; then
    echo "version is 10.7 or 10.8"
    curl -L https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg -O
    sudo installer -pkg /tmp/$GCC_7 -target $GA_LIB
  else
    echo "could not find supported version for command line tools"
  fi
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
  rvm use 2.0.0 --default
  echo "...done"
}

install_rails() {
  echo "Installing rails..."
  gem install -v 4.0.0 rails
  echo "...done"
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
GA_LIB="~/ga/lib"

echo "creating a directory for ga tools at ~/ga/lib"
mkdir -p $GA_LIB

if [[ $OS == "darwin" ]]; then
  echo "Mac OS X.. An aristocrat, eh?"

  install_mac_tools

  install_ruby

  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  echo "Updating..."
  brew update
  echo "...done"

  echo "Installing git..."
  brew install git
  config_git
  echo "...done"

  install_bundler

  install_rails

  echo "Downloading and installing SublimeText"
  cd /tmp && wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg
  sudo hdiutil attach /tmp/Sublime\ Text\ 2.0.2.dmg
  sudo installer /Volumes/Sublime\ Text\ 2.0.2/Sublime\ Text\ 2.0.2.pkg -target /Applications
  sudo hdiutil detach /tmp/Sublime\ Text\ 2.0.2.dmg
  echo "...done"

  subl_to_path .bash_profile

  check_install

elif [[ $OS == "linux" ]]; then
  echo "Ah, classy operating system!"

  echo "Installing curl..."
  sudo apt-get install -y curl
  echo "...done"

  install_ruby

  echo "Installing git..."
  sudo apt-get install -y build-essential git-core
  config_git
  echo "...done"

  install_bundler

  install_rails

  echo "Downloading and installing SublimeText"
  cd /tmp && wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
  tar xjvf /tmp/Sublime\ Text\ 2.0.2.tar.bz2 -C ~/ga/lib
  echo "...done"

  subl_to_path .bashrc

  check_install
  echo "You are set for BEWD! Go forth and program!"
fi
