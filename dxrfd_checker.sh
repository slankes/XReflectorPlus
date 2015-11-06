#!/bin/bash 
echo 
echo "_________________________________________________________________________"
echo
echo -e "\e[4mDXRFD Network connections:\e[24m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i xrf
echo
echo -e "\e[4mDXRFD Prozesses:\e[24m"
/usr/bin/ps -aux | /usr/bin/grep xrf | /usr/bin/grep -v grep
echo
echo -e "\e[4mDXRFD Website:\e[24m"
/usr/bin/netstat -atulpen | /usr/bin/grep -i http
echo "_________________________________________________________________________"
echo
