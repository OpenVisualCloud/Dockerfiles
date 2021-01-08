#!/bin/bash -e

IMAGE="xeone3-centos8-media-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
