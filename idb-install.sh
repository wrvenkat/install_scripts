#!/bin/bash

#just staitcally fix Ruby version
RUBY_VER="2.2.3"

DEPS0="ruby-build ruby-bundler"
DEPS1="cmake libqt4-dev git-core libimobiledevice-utils libplist-utils usbmuxd libxml2-dev libsqlite3-dev"
DEPS2="ruby2.3-dev libqtruby4shared2 libsmokeqt*4-3"
GIT_REPO="https://github.com/dmayer/idb"
CLONE_DIR=~/Documents/idb

#check git and install
if ! type git &> /dev/null; then
    printf "Git not found. Installing Git."
    if ! sudo apt-get install git -y &> /dev/null; then
	printf "Git installation failed. Exiting.\n"
	exit 1
    fi
fi

#install dependencies
if ! sudo apt-get install -y $DEPS1 $DEPS2; then
    printf "Failed to install dependencies.\n"
    exit 1
fi

#install ruby build and bundler
if ! sudo apt-get install -y $DEPS0; then
    printf "Failed to install ruby-build.\n"
    exit 1.
fi

#install ruby with CONFIGURE_OPTS
CONFIGURE_OPTS=--enable-shared
if ! rbenv install -f "$RUBY_VER"; then
    printf "Failed to install Ruby.\n"
    exit 1
fi

#install bye bug
if ! sudo gem install byebug; then
    printf "Failed to install ByeBug. Exiting\n."
    exit 1
fi

#clone the repo
if ! git clone "$GIT_REPO" $CLONE_DIR; then
    printf "Failed to clone repo. Exiting.\n"
    exit 1
fi

#check out latest version
cd $CLONE_DIR
latestTag="$(git tag -l | sort -V | tail -1)"
if ! git checkout tags/"$latestTag"; then
    printf "Error checking out latest version.\n"
    exit 1
fi

#build/install
if ! sudo bundle install; then
    printf "Failed to build gem for idb.\n"
    exit 1
fi

printf "idb installed.\n"
printf "To run type bundle exec idb in the idb directory.\n"
exit 0
