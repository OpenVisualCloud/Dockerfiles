#!/bin/bash -e

IMAGE="xeon-centos8-media-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
