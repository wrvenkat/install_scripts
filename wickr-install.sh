#!/bin/bash
#Installs Wickr

#64-bit
wickr_download_url="https://mywickr.info/download.php?p=364"
wickr_name="wickr_latest.deb"

if wget --no-check-certificate "$wickr_download_url" -O "$wickr_name" && sudo dpkg -i "$wickr_name"; then
    rm "$wickr_name"
    exit 0
else
    printf "Failed to install Wickr.\n"
    rm "$wickr_name"
    exit 1
fi
