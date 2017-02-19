#!/bin/bash

#This script installs psensor
PSENSOR_DEPENDENCIES="libsensors4-dev libgtk-3-dev libnotify-dev libappindicator3-dev libxnvctrl-dev libxnvctrl0 libjson-c-dev libunity-dev libatasmart-dev libudisks2-dev help2man"

detect_sensors(){
    if sudo apt-get install -y lm-sensors; then
	if yes | sudo sensors-detect; then
	    return 0
	else
	    return
	fi
    else
	return 1
    fi
}

#accepts 1 arg
# 0 - implies install from PPA, 1 - implies install from source
psensor_install(){
    #install pensor from PPA
    if [ "$1" -eq 0 ]; then
	#first detect and create the sensors config
	if detect_sensors; then
	   sudo apt-get update
	   if sudo apt-get install psensor; then
	       return 0
	   else
	       return 1
	   fi
	fi
    elif [ "$1" -eq 1 ]; then
	#first detect and create the sensors config
	if ! detect_sensors; then
	    return 1
	fi
	if git clone http://git.wpitchoune.net/psensor.git "git repo/psensor"; then
	cd "git repo/psensor"
	local latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
	git checkout "$latestTag"
	if yes | sudo apt-get install -y --allow-unauthenticated $PSENSOR_DEPENDENCIES; then
	    if ./configure && make && sudo make install; then
		sudo apt-get remove -y $PSENSOR_DEPENDENCIES
		return 0
	    else
		return 1
	    fi
	else
	    return 1
	fi
	else
	    return 1
	fi
    fi
}

#install psensor from source (0 means from PPA)
psensor_install 1
exit $?
