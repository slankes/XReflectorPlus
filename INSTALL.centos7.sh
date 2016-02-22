#!/bin/bash

#============================================================
#
#          FILE: INSTALL.centos7.sh
#
#         USAGE:  ./INSTALL.centos7.sh
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
#       CREATED:  05/11/2015 15:42:08 UTC
#      REVISION:  0.1
#============================================================

#
# FUNCTIONS
#
function do_compiling {
	#g++ -W -Wall -fPIE -fstack-protector-all -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -g -o dxrfd dxrfd.cpp -lrt -pthread
        #g++ -W -Wall -g -o dxrfd dxrfd.cpp -lrt -pthread
        gcc dxrfd.cpp -lstdc++ -lrt -lpthread -g -D_GNU_SOURCE -o dxrfd
}

#
#FLOW starts here
#
# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
    echo -e '\e[31mError: this script can only be executed by root!\e[0m'
    exit 1
fi

clear
echo "...."
echo "Now we are installing the XRF Reflector in to directory /opt/dxrfd/"
echo "This script install everything we need and compile the dxrfd Daemon."
echo "Also the config file will be changed."
echo
read -p 'Do you realy want to proceed? [y/n]): ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye and 73...'
	logger -t dxrfd " installing canceld"
        exit 1
    fi
echo "."

# Detect OS
case $(head -n1 /etc/redhat-release | cut -f 1 -d ' ') in
    CentOS)     type="centos" ;;
    *)          echo -e "\e[31mSorry, this script only works on CentOS 7\e[0m"; exit 1; ;;
esac


echo "."
echo "Fasten your seatbelts, let´s begin"
echo "."

echo "Searching for ......."
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
	yum -y install wget
	logger -t dxrfd " installing wget"
	wget -q http://vk4tux.duckdns.org/OD/DExtra_Hosts.txt
	wget -q http://vk4tux.duckdns.org/OD/DPlus_Hosts.txt
	grep '^XRF' DExtra_Hosts.txt > xrfs.txt
	grep '^REF' DPlus_Hosts.txt >> xrfs.txt
	rm -f DExtra_Hosts.txt
	rm -f DPlus_Hosts.txt
fi


# We need make
which make
if [ $? -eq 0 ]; then
	yum -y install make
	logger -t dxrfd " installing make "
else 
	echo -e "...........\e[\92mfound\e[0m"
fi

#
which gcc
if [ $? -gt 0 ]; then
	echo -e "Sorry, gcc compiler \e[91mnot found\e[0m. But we can install it for you."
	yum -y install gcc gcc-c++
	do_compiling
else
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

# Do the Configuration 
echo "Now, the config file has to be changed!"
read -p 'Do you want to proceed? [y/n]): ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye'
        exit 1
    fi

#Config File 
if [[ -x "/usr/bin/dos2unix"]]; 
	/usr/bin/dos2unix /opt/dxrfd/dxrfd.cfg
else 
	yum -y install dos2unix
	logger -t dxrfd " installing dos2unix"
	/usr/bin/dos2unix /opt/dxrfd/dxrfd.cfg
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




# Install the Dashboard 
echo "Next, you should install a Online Web-Dashboard, so every one can see who is using your Reflector!"
read -p 'Do you want to proceed? [y/n]): ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye'
        exit 1
    fi

# Check if httpd is installed
rpm -q httpd
if [ $? -gt 0 ]; then
        yum -y install httpd php
	systemctl start httpd.service
	systemctl enable httpd.service
	firewall-cmd --permanent --zone=public --add-service=http 
	firewall-cmd --permanent --zone=public --add-service=https
	firewall-cmd --reload
	
	echo "Configuring httpd....."
     ln -s /opt/dxrfd/config/apache.conf /etc/httpd/conf.d/dxrfd.conf
     systemctl restart httpd.service
     
     echo "DO NOT FORGET TO EDIT YOUR DASHBOARD"
     echo "  vim /opt/dxrfd/public_html/configuration.php"
     

fi



#SETUP CENTOS FIREWALL


# systemctl start firewalld
# firewall-cmd --get-active-zones
# firewall-cmd --zone=public --list-all
# firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --zone=public --add-port=443/tcp --permanent
# firewall-cmd --zone=public --add-port=30001/udp --permanent
# firewall-cmd --reload
# firewall-cmd --zone=public --list-all


# Congrats
echo '======================================================='
echo
echo
echo 'Congratulations,'
echo 'you have successfully installed DXRFD Refector Software.'
echo
echo But, we highly recommend to install also 
echo    yum install fail2ban rkhunter logwatch 
echo for security reason.
echo
echo '======================================================='
logger -t dxrfd " installing is finished, let´s have fun..."
exit 0;
