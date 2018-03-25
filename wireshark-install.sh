#!/bin/bash

if ! sudo apt-get update; then
    printf "Report update failed. Exiting\n"
    exit 1
fi

if ! sudo apt-get install -y --allow-unauthenticated wireshark; then
    printf "Wireshark installation failed. Exiting.\n"
    exit 1
fi

#allow non-root for wireshark by setting debconf selections; adding a wireshark group and adding the current user to that
if ! echo wireshark-common wireshark-common/install-setuid select true | sudo debconf-set-selections && sudo groupadd wireshark && sudo usermod -a -G wireshark $USER; then
    printf "Adding non-root capture failed. Exiting\n"
    exit 1
fi

exit 0
