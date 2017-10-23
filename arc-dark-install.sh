#!/bin/bash

#Installs and sets the Ambiance-Dark-Red as the current theme
ADR_DEB_REPO="deb http://ppa.launchpad.net/noobslab/themes/ubuntu"
ADR_SRC_REPO="# deb-src http://ppa.launchpad.net/noobslab/themes/ubuntu"
ADR_RELEASE='trusty'
REPO_FILE_NAME="noobslab-ubuntu-themes-"
REPO_LOC="/etc/apt/sources.list.d"
REPO_STR="/noobslab/themes"
THEME_NAME="Arc-Dark"
INSTALL_NAME="arc-theme"

#get the release
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

#check if already present, if not add
if ! grep -q "$REPO_STR" /etc/apt/*.list /etc/apt/sources.list.d/*; then
    REPO_LOC=$(printf "%s/%s%s.list" "$REPO_LOC" "$REPO_FILE_NAME" "$release")
    printf "Adding Theme repository..."
    if sudo su -c "printf '%s %s main\n%s %s main\n' '$ADR_DEB_REPO' '$ADR_RELEASE' '$ADR_SRC_REPO' '$ADR_RELEASE' > '$REPO_LOC'"; then
	:
    else
	printf "Unable to add repository location. Please do it manually."
	exit 1
    fi
fi

printf "Refreshing repository..."
retVal=$(sudo apt-get update 2>&1)
retVal=1
if [ "$retVal" -eq 1 ]; then
    printf "Installing theme..."
    msg=$(sudo apt-get install -y --allow-unauthenticated "$INSTALL_NAME" 2>&1)
    retVal=$?
    if [ "$retVal" -eq 0 ]; then
	#printf " Done\n"
	printf "Enabling theme..."
	if gsettings set org.gnome.desktop.wm.preferences theme "$THEME_NAME" && gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"; then
	    printf "Done\n"
	    exit 0
	else
	    printf "Error enabling theme. Please run \"gsettings set org.gnome.desktop.wm.preferences theme '%s' && gsettings set org.gnome.desktop.interface gtk-theme '%s'\" manually." "$THEME_NAME" "$THEME_NAME"
	    exit 1
	fi
    else
	printf "Error installing %s theme. Error: \n%s\n" "$THEME_NAME" "$msg"
	exit 1
    fi
else
    printf "Failed to refresh repository. Please refresh and install manually."
    exit 1
fi
