#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-analytics-ffmpeg"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
