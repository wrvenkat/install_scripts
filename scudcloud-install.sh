#!/bin/bash
#Installls scudcloud

ppa_url="rael-gc/scudcloud"

#check if not present
if ! grep -q "$ppa_url" /etc/apt/*.list /etc/apt/sources.list.d/* >> /dev/null 2>&1; then
    if ! sudo add-apt-repository ppa:"$ppa_url" -y; then
	printf "Error adding to repository.\n"
	exit 1
    fi
else
    printf "Already present in repository.\n"
fi

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt-get update
if ! sudo apt-get install -y --allow-unauthenticated scudcloud; then
    printf "Error installing scudcloud. Exiting\n"
    exit 1
fi
exit 0
