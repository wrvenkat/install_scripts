#!/bin/bash

#Installs spotify

if ! source "helper scripts/logger.sh"; then
    printf "Unable to find logger. Exiting."
    exit 1
fi

#check if spotify already added
if [ $(ls /etc/apt/sources.list.d/ | grep spotify | wc -l) -eq 0 ]; then
    msg=$(printf "Adding Spotify repository...")
    log_error 0 "$msg"
    if sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 && echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list; then
	#printf " Done\n"
	msg=$(printf "Refreshing repository....")
	log_error 0 "$msg"
	status=$(sudo apt-get update)
	#printf " Done\n"
    else
	msg=$(printf "Failed to add spotify. Please consult Spotify website.")
	log_error 1 "$msg"
	return 1
    fi
fi
msg=$(printf "Installing Spotify...")
log_error 0 "$msg"
if yes | sudo apt-get install spotify-client; then
    : #printf "Done\n"
else
    msg=$(printf "Failed to install Spotify. Please consult Spotify website.")
    log_error 1 "$msg"
    exit 1
fi
