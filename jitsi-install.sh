#!/bin/bash
#Installs jitsi - https://jitsi.org/

jitsi_entry="deb https://download.jitsi.org stable/"
jitsi_repo_list="/etc/apt/sources.list.d/jitsi-stable.list"
jitsi_key_url="https://download.jitsi.org/jitsi-key.gpg.key"

#check if already present
if grep -q "$jitsi_entry" /etc/apt/sources.list.d/*; then
    printf "Repository already present.\n"
else
    if wget -q "$jitsi_key_url" -O- | sudo apt-key add -\
	    && sudo sh -c "echo $jitsi_entry > $jitsi_repo_list"; then
	:
    else	
	printf "Failed to add repository. Exiting\n"
	exit 1
    fi
fi
sudo apt-get update
if ! sudo apt-get install -y --allow-unauthenticated jitsi; then
    printf "Error installing jitsi.\n"
    exit 1
fi
exit 0
