#!/bin/bash

key_url="https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public"

#check if HipChat already added
if [ $(ls /etc/apt/sources.list.d/ | grep hipchat | wc -l) -eq 0 ]; then
    printf "Adding HipChat to repository..."
    if ! sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'; then
	printf "Failed to add HipChat to repository...\n"
	exit 1
    fi
    if ! wget -O - "$key_url" | sudo apt-key add -; then
	printf "Failed to add HipChat key....\n"
	exit 1
    fi
fi
$(sudo apt-get update)
printf "Installing HipChat..."
if sudo apt-get install -y hipchat4; then
    :
else
    printf "Failed to install HipChat. Please consult HipChat website.\n"
    exit 1
fi
exit 0
