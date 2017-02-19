#!/bin/bash
#Installs GNU ring - https://ring.cx/en

#Hmmm only 16.04 it seems.
ring_entry="deb https://dl.ring.cx/ring-nightly/ubuntu_16.04/ ring main"
ring_repo_list="/etc/apt/sources.list.d/ring-nightly-man.list"

#check if already present
if grep -q "$ring_entry" /etc/apt/sources.list.d/*; then
    printf "Repository already present.\n"
else
    if sudo apt-key adv --keyserver pgp.mit.edu --recv-keys A295D773307D25A33AE72F2F64CD5FA175348F84\
	    && sudo sh -c "echo $ring_entry > $ring_repo_list" \
	    && sudo add-apt-repository universe; then
	:
    else
	printf "Failed to add to repository.\n"
	exit 1
    fi
fi
sudo apt-get update
if ! sudo apt-get install -y ring; then
    printf "Failed to install ring.\n"
    exit 1
fi
exit 0
