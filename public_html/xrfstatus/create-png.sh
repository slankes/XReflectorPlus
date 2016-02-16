#!/bin/sh
# Based on https://www.void.gr/kargig/blog/2007/03/21/round-trip-and-packet-loss-stats-with-rrdtool/

if [ -z "$1" ]
  then
    echo "No argument supplied"
        echo $(basename "$0")
    exit 1;
fi


PNGDIR=/opt/dxrfd/pbulic_html/xrfstatus/png
DBDIR=/opt/dxrfd/pbulic_html/xrfstatus/rrdb
RDT=/usr/bin/rrdtool
HIGH="200"
WIDTH="800"

$RDT graph $PNGDIR/$1.week.png -h $HIGH -w $WIDTH -a PNG \
--title="RTT for $1 by last 2 weeks" \
--imginfo '<IMG class="img-responsive" SRC=/xrfstatus/png/%s WIDTH=%lu HEIGHT=%lu >' \
--lazy --start -1209600 --end -60 \
-v "Round-Trip Time (ms)" \
--rigid \
--lower-limit 0 \
--upper-limit 500 \
DEF:roundtrip=$DBDIR/$1.rrd:rtt:AVERAGE \
DEF:packetloss=$DBDIR/$1.rrd:pl:AVERAGE \
CDEF:PLNone=packetloss,0,2,LIMIT,UN,UNKN,INF,IF \
CDEF:PL2=packetloss,2,8,LIMIT,UN,UNKN,INF,IF \
CDEF:PL15=packetloss,8,15,LIMIT,UN,UNKN,INF,IF \
CDEF:PL25=packetloss,15,25,LIMIT,UN,UNKN,INF,IF \
CDEF:PL50=packetloss,25,50,LIMIT,UN,UNKN,INF,IF \
CDEF:PL75=packetloss,50,75,LIMIT,UN,UNKN,INF,IF \
CDEF:PL100=packetloss,75,100,LIMIT,UN,UNKN,INF,IF \
AREA:roundtrip#4444ff:"Round Trip Time (millis)" \
GPRINT:roundtrip:LAST:"Cur\: %5.2lf" \
GPRINT:roundtrip:AVERAGE:"Avg\: %5.2lf" \
GPRINT:roundtrip:MAX:"Max\: %5.2lf" \
GPRINT:roundtrip:MIN:"Min\: %5.2lf\n" \
AREA:PLNone#6c9bcd:"0-2%":STACK \
AREA:PL2#00ffae:"2-8%":STACK \
AREA:PL15#ccff00:"8-15%":STACK \
AREA:PL25#ffff00:"15-25%":STACK \
AREA:PL50#ffcc66:"25-50%":STACK \
AREA:PL75#ff9900:"50-75%":STACK \
AREA:PL100#ff0000:"75-100%":STACK \
COMMENT:"(Packet Loss Percentage)"

