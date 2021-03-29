#!/bin/bash -e

IMAGE="vcaca-ubuntu2004-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
