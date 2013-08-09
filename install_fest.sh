#!/bin/bash

set -e

lowercase(){
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

install_bundler() {
  echo "Installing bundler..."
  gem install bundler
  echo "...done"
}

install_ruby() {
  echo "Installing Ruby..."
  curl -L https://get.rvm.io | bash -s stable --ruby
  source /home/vagrant/.rvm/scripts/rvm
  rvm use 2.0.0 --default
  echo "...done"
}

install_rails() {
  echo "Installing rails..."
  gem install -v 4.0.0 rails
  echo "...done"
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

if [[ $OS == "darwin" ]]; then
  echo "Mac OS X.. An aristocrat, eh?"

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

elif [[ $OS == "linux" ]]; then
  echo "Ah, classy operating system!"

  echo "First, you'll need curl..."
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
  mkdir -p ~/ga/lib
  tar xjvf /tmp/Sublime\ Text\ 2.0.2.tar.bz2 -C ~/ga/lib
  echo "...done"

  # Set environment variable for sublime text
fi
