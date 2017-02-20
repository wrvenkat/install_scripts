#!/bin/bash
#Installs Riot (Matrix Client) - https://riot.im/ and https://riot.im/desktop.html

ubuntu_codename="$(lsb_release --codename | awk '{print $2}')"
riot_entry="$(printf "deb https://riot.im/packages/debian/ %s main" "$ubuntu_codename")"
riot_src_entry="$(printf "#deb-src https://riot.im/packages/debian/ %s main" "$ubuntu_codename")"
riot_repo_list="/etc/apt/sources.list.d/matrix-riot.list"

#check if already present
if grep -q "$riot_entry" /etc/apt/sources.list.d/*; then
    printf "Repository already present.\n"
else
    if wget -q https://riot.im/packages/debian/repo-key.asc -O- | sudo apt-key add -\
	    && sudo su -c "echo '#Ring (Matrix Client)' > $riot_repo_list"\
	    && sudo su -c "echo $riot_entry >> $riot_repo_list"\
	    && sudo su -c "echo $riot_src_entry >> $riot_repo_list"; then
	:
    else	
       printf "Failed to add to repository. Exiting.\n"
       exit 1
    fi
fi
sudo apt-get update
if ! sudo apt-get install -y --allow-unauthenticated riot-web; then
    printf "Error installing riot-web.\n"
    exit 1
fi
exit 0
