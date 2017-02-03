#!/bin/bash

STEAM_DOWNLOAD_LOCATION="https://steamcdn-a.akamaihd.net/client/installer/steam.deb"

#Autoaccepts the license agreement
printf "steam\tsteam/license\tnote\t" | sudo debconf-set-selections &&\
printf "steam\tsteam/question\tselect\tI AGREE" | sudo debconf-set-selections &&\
printf "steam\tsteam/purge\tnote\t" | sudo debconf-set-selections &&\
sudo apt-get install python-apt &&\    
wget "$STEAM_DOWNLOAD_LOCATION" &&\
sudo dpkg -i steam.deb
exit $?
