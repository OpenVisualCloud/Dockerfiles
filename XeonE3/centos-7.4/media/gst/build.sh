#!/bin/bash -e

IMAGE="xeone3-centos74-media-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
