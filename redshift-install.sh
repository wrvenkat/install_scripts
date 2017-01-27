#!/bin/bash

#Installs Redshift from source
REDSHIFT_DEPENDENCIES="autopoint libtool intltool libdrm-dev libxcb1-dev libxcb-randr0-dev libx11-dev libxxf86vm-dev libxext-dev libgeoclue-dev libglib2.0-dev"
CONFIG_OPTIONS="--enable-drm --enable-vidmode --enable-randr --enable-geoclue --enable-geoclue2 --enable-gui --enable-ubuntu"

git &> /dev/null
if [ $? -ne 1 ]; then
    if ! yes | sudo apt-get install git; then
	printf "Unable to install git. Exiting\n"
	exit 1
    fi
fi
git clone https://github.com/jonls/redshift.git "git repo/redshift" && cd "git repo/redshift"
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
if [ -n "$latestTag" ]; then
    git checkout "$latestTag"
    printf "Installing dependencies...\n"
    if yes | sudo apt-get install -y $REDSHIFT_DEPENDENCIES python3; then
	printf "Building redshift..."
	if ./bootstrap && ./configure $CONFIG_OPTIONS && make; then
	    printf "Installing Redshift...\n"
	    if sudo make install; then
		printf "Installation done\n"
		sudo apt-get remove -y $REDSHIFT_DEPENDENCIES
		#cd ..
		#rm -rf redshift
		exit 0
	    fi
	fi
    else
	printf "Failed to install dependencies. Please consult https://github.com/jonls/redshift\n"
    fi
    printf "Failed to build and install. Please consult https://github.com/jonls/redshift\n"
    exit 1
fi
