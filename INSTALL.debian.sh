#!/bin/bash

#============================================================
#
#          FILE: INSTALL.Debian.sh
#
#         USAGE:  ./INSTALL.Debian.sh
#
#   DESCRIPTION: Use this script to install the XRF Reflector
#		 on an easy way.
#
#       OPTIONS:  no
#  REQUIREMENTS:  no
#          BUGS:  unkown
#         NOTES:  ---
#        AUTHOR:   (Klaus),dl5rfk@dl5rfk.org
#       COMPANY:
#       VERSION:  0.1
#       CREATED:  10/10/2015 15:42:08 UTC
#      REVISION:  0.1
#============================================================

#
# FUNCTIONS
#
function do_compiling {
	#g++ -W -Wall -fPIE -fstack-protector-all -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -g -o dxrfd dxrfd.cpp -lrt -pthread
        #g++ -W -Wall -g -o dxrfd dxrfd.cpp -lrt -pthread
        gcc dxrfd.o -lstdc++ -lrt -lpthread -g -D_GNU_SOURCE -o dxrfd
}


#
#FLOW starts here
#
# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi


echo "...."
echo "Now we are installing the XRF Reflector in to directory /root/dxrfd/"
echo "This script install everything we need and compile the dxrfd Deamon."
echo "Also the config file will be changed."
echo
read -p 'Do you realy want to proceed? [y/n]): ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye and 73...'
        exit 1
    fi
echo
echo "Fasten your seatbelts, let´s begin"
echo "Now we are installing the XRF Reflector in to /root/dxrfd/"

# Detect OS
case $(head -n1 /etc/issue | cut -f 1 -d ' ') in
    Debian)     type="debian" ;;
    Ubuntu)     type="ubuntu" ;;
    *)          echo "Sorry, Debian or Ubuntu only !"; exit 1; ;;
esac

echo type

# We need make
which make
if [ $? -eq 0 ]; then
	apt-get -y install make
fi

#we need wget for downloading files
which wget
if [ $? -eq 0 ]; then

	wget -q http://vk4tux.duckdns.org/OD/DExtra_Hosts.txt
	wget -q http://vk4tux.duckdns.org/OD/DPlus_Hosts.txt
	grep '^XRF' DExtra_Hosts.txt > xrfs.txt
	grep '^REF' DPlus_Hosts.txt >> xrfs.txt
	rm -f DExtra_Hosts.txt
	rm -f DPlus_Hosts.txt
else
	apt-get -y install wget
	wget -q http://vk4tux.duckdns.org/OD/DExtra_Hosts.txt
	wget -q http://vk4tux.duckdns.org/OD/DPlus_Hosts.txt
	grep '^XRF' DExtra_Hosts.txt > xrfs.txt
	grep '^REF' DPlus_Hosts.txt >> xrfs.txt
	rm -f DExtra_Hosts.txt
	rm -f DPlus_Hosts.txt
fi


#
which g++
if [ $? -eq 0 ]; then
	do_compiling
else
	echo "Sorry, no g++ compiler found. Please install g++ at first."
	apt-get -y install g++
	do_compiling
fi

#INIT SCRIPT
if [ -e /etc/init.d/dxrfd ]; then
    update-rc.d -f dxrfd defaults
    update-rc.d -f dxrfd enable
else
    cp dxrfd.init /etc/init.d/dxrfd
    chmod 755 /etc/init.d/dxrfd
    update-rc.d -f dxrfd defaults
    update-rc.d -f dxrfd enable
fi

#
echo "Now, the config file has to be changed!"
read -p 'Do you want to proceed? [y/n]): ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye'
        exit 1
    fi

# Define XRFNAME
  if [ -z "$xrfname" ]; then
        read -p "Please enter XRF name [XRF123]: " xrfname
  fi
# Define ADMIN CALLSIGN
  if [ -z "$callsign" ]; then
        read -p "Please enter the Sysop Callsign [DL5RFK]: " callsign
  fi

#MAKE CHANGES IN CFG FILE
cp dxrfd.cfg dxrfd.cfg.bak
eval "sed -i 's/^OWNER=.*/OWNER=$xrfname/' dxrfd.cfg"
eval "sed -i 's/^ADMIN=.*/ADMIN=$callsign/' dxrfd.cfg"

# Congrats
echo '======================================================='
echo
echo
echo 'Congratulations,'
echo 'you have successfully installed DXRFD Refector Software.'
echo
echo
echo '======================================================='
exit 0;
