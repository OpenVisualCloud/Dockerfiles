#!/bin/bash -e

IMAGE="xeone3-centos7-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
