#!/bin/bash -e
image=$2
nodeip=$1
worker="root@$nodeip"
docker save $image | ssh $worker "docker image rm -f $image 2>/dev/null; docker load"
