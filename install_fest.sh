#!/bin/bash

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
  source ~/.bashrc
  rvm use 2.0.0 --default
  echo "...done"
}

OS=`lowercase \`uname\``

if [[ $OS == "windowsnt" ]]; then
  echo "Here's a quarter. Go get yourself a real OS"

elif [[ $OS == "darwin" ]]; then
  echo "Mac OS X.. An aristocrat, eh?"

  install_ruby

  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  echo "Updating..."
  brew update
  echo "...done"

  echo "Installing git..."
  brew install git
  echo "...done"

  install_bundler

  echo "Installing rails..."
  gem install -v 4.0.0 rails
  echo "...done"

  echo "Downloading and installing SublimeText"
  cd /tmp && wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg
  sudo hdiutil attach /tmp/Sublime\ Text\ 2.0.2.dmg
  sudo installer /Volumes/Sublime\ Text\ 2.0.2/Sublime\ Text\ 2.0.2.pkg -target /Applications
  sudo hdiutil detach /tmp/Sublime\ Text\ 2.0.2.dmg
  echo "...done"

elif [[ $OS == "linux" ]]; then
  echo "Ah, classy operating system!"

  echo "First, you'll need curl..."
  sudo apt-get install curl
  echo "...done"

  install_ruby

  echo "Installing git..."
  sudo apt-get install build-essential git-core
  echo "...done"

  install_bundler

  install_rails

  echo "Downloading and installing SublimeText"
  cd /tmp && wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
  mkdir -p ~/ga/lib
  tar xjvf /tmp/Sublime\ Text\ 2.0.2.tar.bz2 -C ~/ga/lib
  echo "...done"

  # Set env
fi


