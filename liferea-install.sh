#!/bin/bash

#Installs Liferea from source

#Fix me to write a script to install the latest stable version
LATEST_STABLE_VERSION=v1.11.7
git &> /dev/null
if [ $? -ne 1 ]; then
    if ! yes | sudo apt-get install git; then
	printf "Unable to install git. Exiting\n"
	exit 1
    fi
fi
git clone https://github.com/lwindolf/liferea.git liferea && cd liferea && git checkout "$LATEST_STABLE_VERSION"
printf "Installing dependencies...\n"
if yes | sudo apt-get install libxslt1-dev libsqlite3-dev libwebkitgtk-3.0-dev libjson-glib-dev libgirepository1.0-dev gsettings-desktop-schemas-dev libpeas-dev; then
    printf "Building Liferea..."
    if ./autogen.sh && make; then
	printf "Installing Liferea...\n"
	if sudo make install; then
	    printf "Installation done\n"
	    cd ..
	    rm -rf liferea
	    exit 0
	fi
    fi
else
    printf "Failed to install dependencies. Please consult https://lzone.de/liferea/install.htm\n"
fi
printf "Failed to build and install. Please consult https://lzone.de/liferea/install.htm\n"
exit 1;
