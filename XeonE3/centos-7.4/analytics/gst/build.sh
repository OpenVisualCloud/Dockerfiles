#!/bin/bash -e

IMAGE="xeone3-centos74-analytics-gst"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
