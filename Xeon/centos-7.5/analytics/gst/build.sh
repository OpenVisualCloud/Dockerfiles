#!/bin/bash -e

IMAGE="xeon-centos75-analytics-gst"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
