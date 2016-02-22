#!/bin/bash 
echo 
echo "_________________________________________________________________________"
echo
echo -e "\e[4mDXRFD Network connections:\e[0m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i xrf
if [ $? -gt 0 ]; then
	echo -e "\e[31m DXRFD IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t dxrfd "DXRFD IS NOT RUNNING, PLEASE CHECK (No Network connections)"
fi
echo
echo -e "\e[4mDXRFD Processes:\e[0m"
/usr/bin/ps -aux | /usr/bin/grep dxrfd | /usr/bin/grep -v grep | /usr/bin/grep -v dxrfd_checker 
if [ $? -gt 0 ]; then
	echo -e "\e[31m DXRFD IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t dxrfd "DXRFD IS NOT RUNNING, PLEASE CHECK (No dxrfd Process found)"
fi
echo
echo -e "\e[4mDXRFD Website:\e[0m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i http
if [ $? -gt 0 ]; then
	echo -e "\e[31m WEBSERVER IS NOT RUNNING, PLEASE CHECK\e[0m"
	/usr/bin/logger -t dxrfd "WEBSERVER IS NOT RUNNING, PLEASE CHECK (No http Process found)"
fi

echo "_________________________________________________________________________"
echo
