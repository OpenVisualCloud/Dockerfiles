#!/bin/bash -e

IMAGE="vca2-centos74-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
