#!/bin/bash -e

IMAGE="vca2-centos74-media-ffmpeg"
VERSION="1.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
