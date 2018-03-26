#!/bin/bash

#See http://www.newosxbook.com/tools/jtool.html

URL="http://www.newosxbook.com/tools/jtool.tar"
target_dir=~/Downloads/

#check for wget
if ! type ; then
    printf "wget not found. Installing wget.\n"
    if ! sudo apt-get install -y wget; then
	printf "wget installation failed. Exiting.\n"
	exit 1
    fi
fi

#download
if ! wget -q "$URL" -O "$target_dir"jtool.tar; then
    printf "jtoll download failed. Exiting.\n"
    exit 1    
fi

#extract jtool
if ! [ -d "$target_dir"jtool/ ]; then
    mkdir "$target_dir"jtool;
fi

if ! tar -xvf "$target_dir"jtool.tar --directory "$target_dir"jtool/; then
    printf "jtool extract failed. Exiting\n";
    exit 1
fi

#rename and move to /bin.
if ! (cd "$target_dir"jtool && mv "$target_dir"jtool "$target_dir"jtool1 && mv "$target_dir"jtool.ELF64 "$target_dir"jtool && sudo cp "$target_dir"jtool /bin/); then
    printf "Failed to copy to /bin. Exiting\n"
    exit 1
fi

printf "Done\n"
exit 0
