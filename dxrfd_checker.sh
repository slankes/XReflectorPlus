#!/bin/bash 
##################################################################################
# --------------------------------------------------------------
# DXRFD Checker
# --------------------------------------------------------------
# Owner/Group......: root/root
# Name:............: check-process.sh
# Location.........: /opt/dxrfd/
# Developer........: Klaus Frose 
# Date.............: 17.11.2015
# Remarks..........:
# Crontab..........: */5 * * * * /opt/dxrfd/dxrfd_checker.sh mail >  /dev/null 2>&1
# -------------------------------------------------------------
# modified                              dd.mm.YYYY      by
#
# erstellung des scripts                13.12.2010      K.Froese
#
################################################################################
#VARIABLE


PIDFILE=/var/run/syslogd.pid
PNAME="DXRFD"
HOSTNAME=`hostname`
SUBJECT="[DXRF850] Error Notification"
EMAIL="username@example.org"
LOGGER=/usr/bin/logger

#
usage () {
 echo
}

notify_error () {
        echo -e " Hello Sysop,\n\n at host $HOSTNAME we have a problem. \n\n Here is the message:\n $PROBLEMMSG \n\n Please fix it. 73 de dxrfd_checker " | mail -s "$SUBJECT" $EMAIL
        $LOGGER -i -t "$PNAME" "$PROBLEMMSG"
}


echo 
echo "_________________________________________________________________________"
echo
echo -e "\e[4mDXRFD Network connections:\e[0m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i xrf
if [ $? -gt 0 ]; then
	echo -e "\e[31m DXRFD IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t $PNAME "DXRFD IS NOT RUNNING, PLEASE CHECK (No Network connections)"
	PROBLEMMSG="No Network connections found"
	notify_error
fi
echo
echo -e "\e[4mDXRFD Processes:\e[0m"
/usr/bin/ps -aux | /usr/bin/grep dxrfd | /usr/bin/grep -v grep | /usr/bin/grep -v dxrfd_checker 
if [ $? -gt 0 ]; then
	echo -e "\e[31m DXRFD IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t $PNAME "DXRFD IS NOT RUNNING, PLEASE CHECK (No dxrfd Process found)"
	PROBLEMMSG="No DXRFD Deamon found"
	notify_error
fi
echo
echo -e "\e[4mDXRFD Website:\e[0m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i http
if [ $? -gt 0 ]; then
	echo -e "\e[31m WEBSERVER IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t $PNAME "WEBSERVER IS NOT RUNNING, PROBLEMPLEASE CHECK (No http Process found)"
	PROBLEMMSG="No Webserver Port found, i´ll try to restart httpd now!"
	notify_error
	systemctl restart httpd
	
fi

echo "_________________________________________________________________________"
echo
