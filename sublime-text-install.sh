#!/bin/bash

#Installs sublime-text

#check if sublimetext already added
if [ $(ls /etc/apt/sources.list.d/ | grep sublimetext | wc -l) -eq 0 ]; then
    printf "Adding sublimetext key repository..."
    if ! wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -; then	
	printf "Failed to add sublime text key.\n"
	exit 1
    fi
    printf "Enabling apt to access over HTTPS.\n"
    if ! sudo apt-get install apt-transport-https; then
	printf "Failed to enable apt access over HTTPS\n"
	exit 1
    fi    
    printf "Adding sublimetext to repository..."
    if ! echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list; then
	printf "Failed to add sublime text to repository.\n"
	exit 1
    fi
fi
printf "Refreshing repository..."
status=$(sudo apt-get update)
printf "Installing sublimetext..."
if ! sudo apt-get install -y --allow-unauthenticated sublime-text; then
    printf "Failed to install Spotify. Please consult Spotify website.\n"
    exit 1
fi
