#/bin/bash 

#VARIABLE
DOMAIN=refl.up4dar.de
WWWDIR=/opt/dxrfd/public_html

PING=$WWWDIR/xrfstatus/ping.sh
DIRRRDB=$WWWDIR/xrfstatus/rrdb
DIRPNG=$WWWDIR/xrfstatus/png
CREATEDB=$WWWDIR/xrfstatus/create-rrd-database.sh
CREATEPNG=$WWWDIR/xrfstatus/create-png.sh
HTMLFILE=$WWWDIR/xrfstatus/images.php

echo " " > $HTMLFILE

#PROGRAMM
LISTE=( xrf022 xrf024 xrf232 xrf262 xrf423 xrf433 xrf456 xrf747 )
for REF in ${LISTE[*]} 
do 
if [ -a $DIRRRDB/$REF.$DOMAIN.rrd ];then
	$PING $REF.$DOMAIN
	$CREATEPNG $REF.$DOMAIN >> $HTMLFILE
else 
	$CREATEDB $REF.$DOMAIN	
fi
done

exit 0;
