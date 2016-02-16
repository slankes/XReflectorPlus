#!/bin/bash


# ----------------------------------------------------------------------
#title       :
#description : This script tail the log file
#author          : DL5RFK
#date        : 2015-11-06
#version     : 0.4
#usage           : bash ./tail.log
#notes       :
#licenze     : GNU GPL v3
# ----------------------------------------------------------------------


# Detect OS
case $(head -n1 /etc/redhat-release | cut -f 1 -d ' ') in
    CentOS)     /usr/bin/tail -f /var/log/messages |/usr/bin/grep xrf;;
    *)          /usr/bin/tail -f /var/log/syslog;;
esac


