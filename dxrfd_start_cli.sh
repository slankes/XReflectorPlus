#!/bin/bash

# ----------------------------------------------------------------------
#title       : 
#description : This script will help you to controll your DXRFD Reflector
#author		 : DL5RFK
#date        : 2015-11-06
#version     : 0.4    
#usage		 : bash ./dxrfd_start.cli.sh 
#notes       : 
#licenze     : GNU GPL v3
# ----------------------------------------------------------------------



echo
echo "+-----------------------------------------------------------------+"
echo "| DXRFD Command Line Interface                                    |"
echo "|       You can control your own Reflector in a easy way          |"
echo "|                                                                 |"
echo "| Type one of the following commands and watchout the response    |"
echo "|                                                                 |"
echo "| To link a remote Reflector with your own type lrf               |"
echo "| lrf [OwnModul^RemoteReflector^RemoteModul] Example: AXRF232A    |"
echo "|                                                                 |"
echo "| List of other Commands                                          |"
echo "| pu   => Print users                                             |"
echo "| pv   => Print version                                           |"
echo "| pb   => Print blocked users                                     |"
echo "| pl   => Print Links                                             |"
echo "| qsoy => QSO Details yes                                         |"
echo "| qson => QSO Details no                                          |"
echo "| sh   => Shutdown reflector                                      |"
echo "| mu   => Mute users                                              |"
echo "| uu   => Unmute users                                            |"
echo "| upd  => Update Database                                         |"
echo "|                                                                 |"
echo "| Type strg+c to exit the cli                                     |"
echo "|                                                                 |"
echo "+-----------------------------------------------------------------+"
echo

nc -u localhost 30002
