#!/bin/bash -e

IMAGE="xeon-centos74-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
