#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-media-ffmpeg"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
