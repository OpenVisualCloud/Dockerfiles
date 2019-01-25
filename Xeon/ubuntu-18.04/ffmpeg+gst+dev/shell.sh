#!/bin/bash -e

IMAGE="xeon-ubuntu1804-ffmpeg-gst-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
