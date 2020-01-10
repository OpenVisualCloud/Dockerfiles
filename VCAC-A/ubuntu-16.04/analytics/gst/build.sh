#!/bin/bash -e

IMAGE="vcaca-ubuntu1604-analytics-gst"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
