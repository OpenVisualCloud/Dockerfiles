#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
DIR=$(dirname $(readlink -f "$0"))
for device in /dev/qat* /dev/usdm_drv /dev/uio*; do
    DEVICE_DIR="--device=$device:$device $DEVICE_DIR"
done

for tmp in /var/tmp/shm_key_uio_ctl_lock; do
    DEVICE_DIR="-v $tmp:$tmp $DEVICE_DIR"
done

DEVICE_DIR="--privileged"

. "${DIR}/../../../../script/shell.sh"
