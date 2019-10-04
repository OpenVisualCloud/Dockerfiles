#!/bin/bash -e

IMAGE="vcaca-ubuntu1804-analytics-gst"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
