#!/bin/bash
#Installs tox https://tox.chat/

ubuntu_release="$(lsb_release --release | awk '{print $2}')"
tox_entry="$(printf "deb http://download.opensuse.org/repositories/home:/antonbatenev:/tox/xUbuntu_%s/ /" "$ubuntu_release")"
tox_key_url="$(printf "http://download.opensuse.org/repositories/home:antonbatenev:tox/xUbuntu_%s/Release.key" "$ubuntu_release")"
tox_repo_list="/etc/apt/sources.list.d/qtox.list"

printf "Tox_entry is: %s\nTox_key_URL:%s\nTox_repo_list:%s\n" "$tox_entry" "$tox_key_url" "$tox_repo_list"

#check if already present
if grep -q "$tox_entry" /etc/apt/sources.list.d/*; then
    printf "Repository already present.\n"
else
    if wget -q "$tox_key_url" -O- | sudo apt-key add -\
	    && sudo sh -c "echo $tox_entry > $tox_repo_list"; then
	:
    else	
	printf "Failed to add repository. Exiting\n"
	exit 1
    fi
fi
sudo apt-get update
if ! sudo apt-get install -y qtox; then
    printf "Error installing qtox.\n"
    exit 1
fi
exit 0
