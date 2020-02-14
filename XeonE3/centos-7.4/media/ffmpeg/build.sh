#!/bin/bash -e

IMAGE="xeone3-centos74-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
