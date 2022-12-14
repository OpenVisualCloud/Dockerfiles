#!/bin/bash -e

IMAGE="sg1-ubuntu2204-media-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
