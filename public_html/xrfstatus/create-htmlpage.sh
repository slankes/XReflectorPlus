/bin/bash

#VARIABLE
DOMAIN=reflector.up4dar.de
WWWDIR=/opt/dxrfd/public_html
PING=/var/www/html/xrfstatus/ping.sh
DIRRRDB=$WWWDIR/xrfstatus/rrdb
DIRPNG=$WWWDIR/xrfstatus/png
CREATEDB=$WWWDIR/xrfstatus/create-rrd-database.sh
CREATEPNG=$WWWDIR/xrfstatus/create-png.sh
HTMLFILE=$WWWDIR/xrfstatus/images.php

echo " " > $HTMLFILE


#PROGRAMM
#if [date +%h -eq 00 ]; then rm -f $DIRPNG/*.png; fi

LISTE=( xrf022 xrf024 xrf232 xrf262 xrf311 xrf423 xrf433 xrf440 xrf456 xrf518 xrf747 )
for REF in ${LISTE[*]}
do
if [ -a $DIRRRDB/$REF.$DOMAIN.rrd ];then
        $PING $REF.$DOMAIN
        $CREATEPNG $REF.$DOMAIN >> $HTMLFILE
        echo " <br> " >> $HTMLFILE
else
        $CREATEDB $REF.$DOMAIN
fi
done
