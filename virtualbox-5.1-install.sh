#!/bin/bash

# Install VBox on your Ubuntu release
VBOX_DEB_REPO="deb http://download.virtualbox.org/virtualbox/debian"
VBOX_SRC_REPO="# deb-src http://download.virtualbox.org/virtualbox/debian"

index=0
for release in $(lsb_release -c); do
    if [ $index -eq 1 ]; then
	release=$release
    fi
    ((index+=1))
done

if [ -z "$release" ]; then
    printf "Unable to determine release\n"
    exit 1
fi

printf "Installing any pending updates\n"
sudo apt-get upgrade -y --allow-unauthenticated

printf "Installing dependencies - dkms libqt5x11extras5 libsdl1.2debian ...\n"

if sudo apt-get install -y --allow-unauthenticated dkms && sudo apt-get install -y --allow-unauthenticated libqt5x11extras5 libsdl1.2debian; then
    printf "Done\n"
    if [ $(cat /etc/apt/sources.list | grep virtualbox | wc -l) -eq 0 ]; then
	printf "Adding VirtualBox repository...."
	if sudo su -c "printf '%s %s contrib\n%s %s contrib\n' '$VBOX_DEB_REPO' '$release' '$VBOX_SRC_REPO' '$release' >> /etc/apt/sources.list"; then
	    printf "Done\n"
	    printf "Adding VBox keys...."
	    if wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add - && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add - ; then
		printf "Done\n"
	    else
		printf "\nError adding VBox keys. Please go to https://www.virtualbox.org/wiki/Linux_Downloads\n"
		exit 1
	    fi
	else
	    printf "Failed\n"
	    exit 1
	fi
    fi
    printf "Refreshing repository....\n"
    sudo apt-get update;
    if sudo apt-get install -y --allow-unauthenticated virtualbox-5.1; then
	printf "VirtualBox 5.1 installed\n"
	exit 0
    else
	printf "\nError refreshing and installing. Please run, \"sudo apt-get update && sudo apt-get install virtualbox-5.1\" manually\n"
	exit 1
    fi
else
    printf "\nUnable to install dependencies\n"
    exit 1
fi
