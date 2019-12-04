#!/bin/bash -e

ssh-keygen -q -N ""  < /dev/zero

NODEUSER="root"
NODEPREFIX="172.32"

sudo vcactl blockio list 2> /dev/null
for nodeip in $(sudo vcactl network ip |grep $NODEPREFIX 2>/dev/null); do
    ssh-copy-id $NODEUSER@${nodeip} 2> /dev/null || echo
done
