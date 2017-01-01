#!/bin/bash

WINE_PPA=ppa:ubuntu-wine/ppa
#add the wine PPA
sudo add-apt-repository -y "$WINE_PPA"
sudo apt-get update
#required to auto-accept MS EULA for fonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt-get install -y wine
type wine
exit $?
