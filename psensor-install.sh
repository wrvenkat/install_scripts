#!/bin/bash

#This script installs psensor
PSENSOR_DEPENDENCIES="libsensors4-dev libgtk-3-dev libnotify-dev libappindicator3-dev libxnvctrl-dev libjson-c-dev libunity-dev libatasmart-dev libudisks2-dev help2man"

if ! source "helper scripts/logger.sh"; then
    printf "Unable to load logger. Exiting.\n"
    exit 1
fi

detect_sensors(){
    if sudo apt-get install -y lm-sensors; then
	if yes | sudo sensors-detect; then
	    return 0
	else
	    log_error 1 "Error running sensors-detect."
	    return
	fi
    else
	log_error 1 "Unable to install lm-sensors. Please see http://wpitchoune.net/psensor/"
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
	       log_error 0 "psensor installed successfully."
	       return 0
	   else
	       log_error 1 "Error installing psensor"
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
		log_error 0 "psensor installed successfully."
		sudo apt-get remove -y $PSENSOR_DEPENDENCIES
		return 0
	    else
		log_error 1 "Unable to compile and install."
		return 1
	    fi
	else
	    log_error 1 "Unable to install dependencies. Please see psensor installation page."
	    return 1
	fi
	else
	    log_error 1 "Unable to clone psensor git reposiroty. Please see http://wpitchoune.net/psensor/"
	    return 1
	fi
    fi
}

#install psensor from source (0 means from PPA)
psensor_install 1
exit $?
