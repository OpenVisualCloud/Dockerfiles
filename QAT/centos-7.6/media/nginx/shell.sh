#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

DEVICE_DIR="-v /dev/hugepages:/dev/hugepages -v /var/tmp:/var/tmp $(ls -1 /etc/*_dev?.conf | sed 's/\(.*\)/-v \1:\1/') $(ls -1 /dev/uio* /dev/qat_* /dev/usdm_drv | sed 's/\(.*\)/--device=\1:\1/')"
. "${DIR}/../../../../script/shell.sh"
