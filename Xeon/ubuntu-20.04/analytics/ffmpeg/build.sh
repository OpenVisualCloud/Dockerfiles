#!/bin/bash -e

IMAGE="xeon-ubuntu2004-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
