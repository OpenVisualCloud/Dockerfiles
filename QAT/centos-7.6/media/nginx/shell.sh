#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

DEVICE_DIR="-v /dev/hugepages:/dev/hugepages --privileged"
. "${DIR}/../../../../script/shell.sh"
