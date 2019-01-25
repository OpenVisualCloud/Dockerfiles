#!/bin/bash -e

IMAGE="vca2-ubuntu1804-ffmpeg-gst-dev"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
