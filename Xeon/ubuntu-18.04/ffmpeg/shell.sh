#!/bin/bash -e

IMAGE="xeon-ubuntu1804-media-ffmpeg"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
