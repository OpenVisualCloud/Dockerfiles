#!/bin/bash -e

IMAGE="xeone3-ubuntu1604-analytics-gst"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
