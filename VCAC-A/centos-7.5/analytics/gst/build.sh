#!/bin/bash -e

IMAGE="vcaca-centos75-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
