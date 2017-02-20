#!/bin/bash

#Autoaccepts the security info and then installs gnome-encfs-manager
printf "encfs encfs/security-information select true" | sudo debconf-set-selections
sudo add-apt-repository -y --allow-unauthenticated ppa:gencfsm/ppa
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated gnome-encfs-manager
exit $?
