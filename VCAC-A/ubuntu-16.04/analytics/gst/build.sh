#!/bin/bash -e

IMAGE="vcaca-ubuntu1604-analytics-gst"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
