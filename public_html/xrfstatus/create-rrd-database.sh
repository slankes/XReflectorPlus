#!/bin/bash
# Based on https://www.void.gr/kargig/blog/2007/03/21/round-trip-and-packet-loss-stats-with-rrdtool/

WWWDIR=/opt/dxrfd/public_html/xrfstatus

if [ -z "$1" ]
  then
    echo "No argument supplied"
        echo $(basename "$0")
    exit 1;
fi

#step => 5min
#pl:Packet Lost
#rrt:round trip time
#600:10min mindestens
#100:rate no more 100
#0.5:1:800 =>
#RRA directive defines how many values the the RRD database will archive and for how long.
#MAX normally means to only accept the maximum value,
#0.5 is an internal resolution value and should _not_ be changed.
#1 specifies how many steps should be averaged before storing the final value.
#800 is how many "steps" we will store in the db. 300 sec * 800 steps = 240000sec / 3600 sec = 66hours
#    this means  66h of 5min resultion, 2,7 Days

/usr/bin/rrdtool create $WWWDIR/rrdb/$1.rrd \
--step 300 \
DS:pl:GAUGE:600:0:100 \
DS:rtt:GAUGE:600:0:10000000 \
RRA:AVERAGE:0.5:1:800 \
RRA:AVERAGE:0.5:6:800 \
RRA:AVERAGE:0.5:24:800 \
RRA:AVERAGE:0.5:288:800 \
RRA:MAX:0.5:1:800 \
RRA:MAX:0.5:6:800 \
RRA:MAX:0.5:24:800 \
RRA:MAX:0.5:288:800

