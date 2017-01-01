#!/bin/bash

#Installs and sets the Ambiance-Dark-Red as the current theme
ADR_DEB_REPO="deb http://ppa.launchpad.net/noobslab/themes/ubuntu"
ADR_SRC_REPO="# deb-src http://ppa.launchpad.net/noobslab/themes/ubuntu"
ADR_RELEASE='trusty'
REPO_FILE_NAME="noobslab-ubuntu-themes-"
REPO_LOC="/etc/apt/sources.list.d"
REPO_STR="/noobslab/themes"

if ! source "helper scripts/logger.sh"; then
    printf "Unable to find logger. Exiting."
    exit 1
fi

#get the release
index=0
for release in $(lsb_release -c); do
    if [ $index -eq 1 ]; then
	release=$release
    fi
    ((index+=1))
done
if [ -z "$release" ]; then
    msg=(printf "Unable to determine release\n")
    log_error 1 "$msg"
    exit 1
fi

#check if already present, if not add
if ! grep -q "$REPO_STR" /etc/apt/*.list /etc/apt/sources.list.d/*; then
    REPO_LOC=$(printf "%s/%s%s.list" "$REPO_LOC" "$REPO_FILE_NAME" "$release")
    msg=$(printf "Adding Ambiance-Dark-Theme repository...")
    log_error 0 "$msg"
    if sudo su -c "printf '%s %s main\n%s %s main\n' '$ADR_DEB_REPO' '$ADR_RELEASE' '$ADR_SRC_REPO' '$ADR_RELEASE' > '$REPO_LOC'"; then
	:
    else
	msg=$(printf "Unable to add repository location. Please do it manually.")
	log_error 1 "$msg"
	exit 1
    fi
fi

msg=$(printf "Refreshing repository...")
log_error 0 "$msg"
retVal=$(sudo apt-get update 2>&1)
retVal=1
if [ "$retVal" -eq 1 ]; then
    msg=$(printf "Installing theme...")
    log_error 0 "$msg"
    msg=$(sudo apt-get install -y --allow-unauthenticated ambiance-dark-red 2>&1)
    retVal=$?
    if [ "$retVal" -eq 0 ]; then
	#printf " Done\n"
	msg=$(printf "Enabling theme...")
	log_error 0 "$msg"
	if gsettings set org.gnome.desktop.wm.preferences theme "Ambiance-Dark-Red" && gsettings set org.gnome.desktop.interface gtk-theme "Ambiance-Dark-Red"; then
	    printf "Done\n"
	    exit 0
	else
	    msg=$(printf "Error enabling theme. Please run \"gsettings set org.gnome.desktop.wm.preferences theme 'Ambiance-Dark-Red' && gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance-Dark-Red'\" manually.")
	    log_error 1 "$msg"
	    exit 1
	fi
    else
	msg=$(printf "Error installing ambiance-dark-red theme. Error: \n%s\n" "$msg")
	log_error 1 "$msg"
	exit 1
    fi
else
    msg=$(printf "Failed to refresh repository. Please refresh and install manually.")
    log_error 1 "$msg"
    exit 1
fi
