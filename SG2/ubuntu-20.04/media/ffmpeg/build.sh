#!/bin/bash -e

IMAGE="sg2-ubuntu2004-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
