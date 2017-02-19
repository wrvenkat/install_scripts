#!/bin/bash

#Install chrome

if wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -; then
    if ! [ -a "/etc/apt/sources.list.d/google.list" ] || ! grep -q http://dl.google.com/linux/chrome/deb/ /etc/apt/sources.list.d/*; then
	if sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'; then
	    :
	else
	    printf "Faield to add repository.\n"
	    exit 1
	fi
    fi
    #Refresh repository and install
    sudo apt-get update
    if sudo apt-get install google-chrome-stable; then
	printf "Installed\n"
	exit 0	    
    else
	printf "Failed to install chrome.\n"
	exit 1
    fi    
else
    printf "Failed to download key.\n"
    exit 1
fi
