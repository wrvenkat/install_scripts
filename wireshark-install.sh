#!/bin/bash

if ! sudo apt-get update; then
    printf "Report update failed. Exiting\n"
    exit 1
fi

#allow non-root for wireshark by setting debconf selections
if ! echo wireshark-common wireshark-common/install-setuid select true | sudo debconf-set-selections; then
    printf "Adding non-root capture failed. Exiting\n"
    exit 1
fi

#install
if ! sudo apt-get install -y --allow-unauthenticated wireshark; then
    printf "Wireshark installation failed. Exiting.\n"
    exit 1
fi

#add the current user to wireshark group
if ! sudo usermod -a -G wireshark $USER; then
    printf "Adding to wireshark group failed. Exiting\n"
    exit 1
fi

exit 0
