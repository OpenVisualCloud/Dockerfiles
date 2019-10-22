#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-analytics-gst"
VERSION="19.10.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
