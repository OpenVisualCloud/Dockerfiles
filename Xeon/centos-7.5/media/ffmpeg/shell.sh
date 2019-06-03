#!/bin/bash -e

IMAGE="xeon-centos75-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
