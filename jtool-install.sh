#!/bin/bash

#See http://www.newosxbook.com/tools/jtool.html

URL="http://www.newosxbook.com/tools/jtool.tar"

#check for wget
if ! type ; then
    printf "wget not found. Installing wget.\n"
    if ! sudo apt-get install -y wget; then
	printf "wget installation failed. Exiting.\n"
	exit 1
    fi
fi

#download
if ! wget -q "$URL" -O ~/Downloads/jtool.tar; then
    printf "jtoll download failed. Exiting.\n"
    exit 1    
fi

#extract jtool
if ! [ -d ~/Downloads/jtool/ ]; then
    mkdir ~/Downloads/jtool;
fi

if ! tar -xvf ~/Downloads/jtool.tar --directory ~/Downloads/jtool/; then
    printf "jtool extract failed. Exiting\n";
    exit 1
fi

#rename and move to /bin.
if ! (cd ~/Downloads/jtool && mv ~/Downloads/jtool ~/Downloads/jtool1 && mv ~/Downloads/jtool.ELF64 ~/Downloads/jtool && sudo cp ~/Downloads/jtool /bin/); then
    printf "Failed to copy to /bin. Exiting\n"
    exit 1
fi

printf "Done\n"
exit 0
