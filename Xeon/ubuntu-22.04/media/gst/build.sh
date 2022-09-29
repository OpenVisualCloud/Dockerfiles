#!/bin/bash -e

IMAGE="xeon-ubuntu2204-media-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
