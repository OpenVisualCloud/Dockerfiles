#!/bin/bash -e

IMAGE="vcaca-ubuntu2004-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
