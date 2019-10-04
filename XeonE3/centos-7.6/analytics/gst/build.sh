#!/bin/bash -e

IMAGE="xeone3-centos76-analytics-gst"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
