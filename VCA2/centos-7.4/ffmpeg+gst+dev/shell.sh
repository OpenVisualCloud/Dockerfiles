#!/bin/bash -e

IMAGE="vca2-centos74-ffmpeg-gst-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
