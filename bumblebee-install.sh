#!/bin/bash

#Installs and configures Bumblebee for on-demand usage of Prime enabled nVidia graphic cards on laptops
# Based on the article from WebUpd8 - http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html

HELP="http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html"
#change this base on the latest stable driver
NVIDIA_STABLE_LATEST=361

# See if nVidia card present
bus_line=$(lspci | egrep 'VGA|3D' | grep NVIDIA)
if [ -z "$bus_line" ]; then
    printf "No nVidia card detected. Exiting\n"
    exit 1
fi

#install the latest driver if no nVidia driver was installed
if [ $(dpkg --list | grep nvidia | wc -l) -eq 0 ]; then
    printf "Installing latest nVidia drivers...\n"
    str=$(printf "nvidia-%s" "$NVIDIA_STABLE_LATEST")
    if yes | sudo apt-get install "$str"; then
	printf "Driver installation done\n"
    else
	printf "Unable to install nvidia binary driver. "
	printf "Please consult %s\n" "$HELP"
	exit 1
    fi
fi

printf "Configuring nVidia prime to use Intel...."
if yes | sudo apt install nvidia-prime && sudo prime-select intel; then
    printf "prime set to use Intel\n"
else
    printf "Failed to install prime and to set to use Intel. "
    printf "Please consult %s\n" "$HELP"
    exit 1
fi

printf "Installing bumblebee..."
if yes | sudo apt-get install bumblebee; then
    printf "bumblebee installation done\n"
else
    printf "Failed to install bumblebee. "
    printf "Please consult %s\n" "$HELP"
    exit 1
fi

#Blacklist the latest driver
blacklist_string=$(printf "# %s\n  nvidia-%s\nblacklist nvidia-%s-updates\nblacklist nvidia-experimental-%s\n" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST")
#add nVidia driver config
config_string=$(printf "Driver=nvidia\nKernelDriver=nvidia-%s\nLibraryPath=/usr/lib/nvidia-%s:/usr/lib32/nvidia-%sXorgModulePath=/usr/lib/nvidia-%s/xorg,/usr/lib/xorg/modules\n" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST" "$NVIDIA_STABLE_LATEST")

if [ -a /etc/modprobe.d/bumblebee.conf ]; then
    printf "Backing up /etc/modprobe.d/bumblebee.conf..."
    sudo su -c "cp /etc/modprobe.d/bumblebee.conf /etc/modprobe.d/bumblebee.conf.backup"
    printf "Configuring bumblebee...\n"
    printf "Blacklisting latest nVidia driver..."
    sudo su -c "printf '%s' '$blacklist_string' >> /etc/modprobe.d/bumblebee.conf"
    printf "Configuring bumblebee to use nVidia binary driver..."
    sudo su -c "printf '%s' '$config_string' >> /etc/modprobe.d/bumblebee.conf"

    # See if BusID needed to be added to /etc/bumblebee/xorg.conf.nvidia
    line_1=$(cat /etc/bumblebee/xorg.conf.nvidia | grep "BusID \"PCI:01")
    line_1=${line_1%" "}
    line_1=${line_1#" "}

    index1=0
    for comment in $line_1;do
	if [ $index1 -eq 0 ]; then
	    if [ "$comment" == "#" ]; then
		printf "BusID commented\n"
		break;
	    else
		#printf "BusID not commented\n"
		printf "Installed and configured bumblebee\n"
		exit 0
	    fi
	fi
    done

    #get Bus ID
    index1=0
    for arr in $bus_line; do
	if [ $index1 -eq 0 ]; then
	    orig_IFS="$IFS"
	    IFS=.
	    index2=0
	    for bus_id in $arr; do
		if [ $index2 -eq 0 ]; then
		    break;
		fi
	    done
	    IFS="$orig_IFS"
	    break;
	fi
    done

    #bus_id="01:00"
    #printf "BusID of nVidia is %s\n" "$bus_id"

    #get BusID line no
    line=$(cat /etc/bumblebee/xorg.conf.nvidia | grep "BusID \"PCI:01" -n)
    index1=0
    for grep_str in $line; do
	if [ $index1 -eq 0 ]; then
	    orig_IFS="$IFS"
	    IFS=:
	    index2=0
	    for line_no in $grep_str; do
		if [ $index2 -eq 0 ]; then
		    break;
		fi
	    done
	    IFS="$orig_IFS"
	    break;
	fi
    done

    #printf "Line no is %s\n" "$line_no"

    #Add uncommented BusID
    if ! sudo su -c "cp /etc/bumblebee/xorg.conf.nvidia /etc/bumblebee/xorg.conf.nvidia.backup"; then
	printf "Failed to create backup of /etc/bumblebee/xorg.conf.nvidia."
	printf "Please consult %s\n" "$HELP"
    fi

    printf "Created backup of /etc/bumblebee/xorg.conf.nvidia\n"

    index1=1
    line=
    msg=
    orig_IFS="$IFS"
    while IFS= ;read line; do
	msg+=$(printf "%s" "$line\n")
	if [ $index1 -eq $line_no ]; then
	    msg+=$(printf "BusID \"PCI:%s:0\"%s" "$bus_id" "\n")
	fi
	((index1+=1))
    done < /etc/bumblebee/xorg.conf.nvidia.backup
    IFS="$orig_IFS"

    printf "$msg" > test.txt
    sudo su -c "cp test.txt /etc/bumblebee/xorg.conf.nvidia"
    rm test.txt
fi

printf "Installed and configured bumblebee\n"
