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
if ! wget -q "$URL" -o jtool.tar; then
    printf "jtoll download failed. Exiting.\n"
    exit 1    
fi

#extract jtool
mkdir jtool
if ! tar -xvf jtool.tar --directory jtool/; then
    printf "jtool extract failed. Exiting\n";
    exit 1
fi

#rename and move to /bin.
if ! cd jtool && mv jtool jtool1 && mv jtool.ELF64 jtool && sudo cp jtool /bin/; then
    printf "Failed to copy to /bin. Exiting\n"
    exit 1
fi

printf "Done\n"
exit 0
