#!/bin/bash -e

IMAGE="xeon-centos76-analytics-gst"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
