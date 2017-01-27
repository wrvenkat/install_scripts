#!/bin/bash

#Installs spotify

#check if spotify already added
if [ $(ls /etc/apt/sources.list.d/ | grep spotify | wc -l) -eq 0 ]; then
    printf "Adding Spotify repository..."
    if sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 && echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list; then
	printf "Refreshing repository...."
	status=$(sudo apt-get update)
    else
	printf "Failed to add spotify. Please consult Spotify website."
	return 1
    fi
fi
printf "Installing Spotify..."
if yes | sudo apt-get install spotify-client; then
    : #printf "Done\n"
else
    printf "Failed to install Spotify. Please consult Spotify website."
    exit 1
fi
