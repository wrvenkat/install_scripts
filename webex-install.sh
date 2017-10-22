#!/bin/bash

webex_dir="/opt/webex/"
#ff51_download_url="https://ftp.mozilla.org/pub/firefox/releases/51.0/firefox-51.0.linux-x86_64.sdk.tar.bz2"
ff51_download_url="https://ftp.mozilla.org/pub/firefox/releases/51.0/firefox-51.0.linux-i686.sdk.tar.bz2"

#jre_path="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/"
jre_path="$webex_dir""jre/"
jre_libs="libawt.so libjawt.so libnpjp2.so"

firefox_plugin_dir="firefox-sdk/bin/browser/plugins"
firefox_java_libs="libawt.so libjawt.so libnpjp2.so"

webex_dependencies="libpangoxft-1.0-0:i386 libxft2:i386 libpangox-1.0-0:i386 libxmu6:i386 libxv1:i386 libasound2-plugins:i386"
elf32_dependencies="libc6:i386 libncurses5:i386 libstdc++6:i386"
firefox32_dependencies="libgtk-3-0:i386 libasound2:i386 libdbus-glib-1-2:i386 libxt6:i386 libxtst6:i386 libcanberra-gtk-module:i386 topmenu-gtk3:i386"

#install 32-bit ELF support
if ! sudo apt-get install -y $elf32_dependencies; then
    printf "Failed to install ELF32 dependencies.\n"
    exit 1
fi

#install Firefox 32-bit dependencies
if ! sudo apt-get install -y $firefox32_dependencies; then
    printf "Failed to install FF 32-bit dependencies.\n"
    exit 1
fi

#install WebEx dependencies
if ! sudo apt-get install -y $webex_dependencies; then
    printf "Failed to install WebEx dependencies.\n"
    exit 1
fi

#Download Java 32-bit and extract to /opt/webex folder
sudo mkdir "$webex_dir" && sudo tar xvf jre.tar.gz -C "$webex_dir" && sudo mv "$webex_dir"jre* "$jre_path"

#Download and extract Firefox 51 to the WebEx folder.
if ! [ -a firefox-51.0.linux-i686.sdk.tar.bz2 ]; then
    if ! wget "$ff51_download_url" >> /dev/null; then
	printf "Failed to download firefox.\n"
	exit 1
    fi
fi

if ! sudo tar xjvf firefox-51.0.linux-i686.sdk.tar.bz2 -C "$webex_dir"; then
    printf "Failed to extract Firefox 51.\n"
    exit 1
fi

#Make the plugin dir for Firefox
if ! sudo mkdir -p "$webex_dir""$firefox_plugin_dir"; then
    printf "Unable to create Firefox plugins directory.\n"
    exit 1
fi

#link the libs to the Firefox plugins dir
lib_str=
for lib in $firefox_java_libs; do
    lib_str="$lib_str""$jre_path""$lib"" "
    printf "Str is %s\n" "$lib_str"
done

if ! sudo ln -s $lib_str "$webex_dir""$firefox_plugin_dir"; then
    printf "Failed to link libs.\n"
    exit 1
fi
