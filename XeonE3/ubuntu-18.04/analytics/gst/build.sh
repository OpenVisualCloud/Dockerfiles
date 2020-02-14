#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
