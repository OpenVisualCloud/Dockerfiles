#!/bin/bash
set -e
image=""

xhost local:root

# the model and videoimage will be stored here
mkdir -p /mnt/share

if test  $1 = "FFMPEG" ; then
    if [ -z $2 ] ; then
        image=openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg:latest
    else
        image=$2
    fi
elif test $1 = "GST" ; then
    if [ -z $2 ] ; then
        image=openvisualcloud/vcaca-ubuntu1804-analytics-gst:latest
    else
        image=$2
    fi
else
    echo "Only support FFMPEG and GST!" 
fi

echo "run $1 $image on VCAC-A"

docker run --rm -it --privileged --net=host \
    -v ~/.Xauthority:/root/.Xauthority \
    -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
    -e DISPLAY=$DISPLAY \
    -e HTTP_PROXY=$HTTP_PROXY \
    -e HTTPS_PROXY=$HTTPS_PROXY \
    -e http_proxy=$http_proxy \
    -e https_proxy=$https_proxy \
    -v /tmp:/tmp -v /dev:/dev  -v /var/tmp:/var/tmp \
    -v /mnt/share:/mnt/share \
    ${image}
