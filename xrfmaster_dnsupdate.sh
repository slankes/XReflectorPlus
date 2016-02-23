#!/bin/bash 
UPDATEKEY=2568D5743D1D1B4D245319835C1B2
REFID=XRFOOO


#
#DO NOT CHANGE
#
/bin/sleep `/usr/bin/expr $RANDOM \% 90` && /usr/bin/wget -O /dev/null -q http://xrfmaster.net/dns/update.php?key=$UPDATKEY\&reflector=$REFID

exit 0;
