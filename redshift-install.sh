#!/bin/bash

#Installs Redshift from source
REDSHIFT_DEPENDENCIES="autopoint libtool intltool libdrm-dev libxcb1-dev libxcb-randr0-dev libx11-dev libxxf86vm-dev libxext-dev libgeoclue-dev libglib2.0-dev"
CONFIG_OPTIONS="--enable-drm --enable-vidmode --enable-randr --enable-geoclue --enable-geoclue2 --enable-gui --enable-ubuntu"

if ! source "helper scripts/logger.sh"; then
    printf "Unable to find logger. Exiting\n"
    exit 1
fi

git &> /dev/null
if [ $? -ne 1 ]; then
    if ! yes | sudo apt-get install git; then
	msg=$(printf "Unable to install git. Exiting\n")
	log_error 1 "$msg"
	exit 1
    fi
fi
git clone https://github.com/jonls/redshift.git "git repo/redshift" && cd "git repo/redshift"
latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
if [ -n "$latestTag" ]; then
    git checkout "$latestTag"
    msg=$(printf "Installing dependencies...\n")
    log_error 0 "$msg"
    if yes | sudo apt-get install -y $REDSHIFT_DEPENDENCIES python3; then
	msg=$(printf "Building redshift...")
	log_error 0 "$msg"
	if ./bootstrap && ./configure $CONFIG_OPTIONS && make; then
	    msg=$(printf "Installing Redshift...\n")
	    log_error 0 "$msg"
	    if sudo make install; then
		msg=$(printf "Installation done\n")
		log_error 0 "$msg"
		sudo apt-get remove -y $REDSHIFT_DEPENDENCIES
		#cd ..
		#rm -rf redshift
		exit 0
	    fi
	fi
    else
	msg=$(printf "Failed to install dependencies. Please consult https://github.com/jonls/redshift\n")
	log_error 1 "$msg"
    fi
    msg=$(printf "Failed to build and install. Please consult https://github.com/jonls/redshift\n")
    log_error 1 "$msg"
    exit 1;
fi
