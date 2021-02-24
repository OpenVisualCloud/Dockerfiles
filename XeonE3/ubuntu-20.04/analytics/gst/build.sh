#!/bin/bash -e

IMAGE="xeone3-ubuntu2004-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
