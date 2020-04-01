#!/bin/bash -e

IMAGE="vcaca-centos74-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
