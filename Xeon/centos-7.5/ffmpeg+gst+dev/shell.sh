#!/bin/bash -e

IMAGE="xeon-centos75-ffmpeg-gst-dev"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
