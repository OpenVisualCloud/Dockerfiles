#!/bin/bash -e

IMAGE="sg1-centos8-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
