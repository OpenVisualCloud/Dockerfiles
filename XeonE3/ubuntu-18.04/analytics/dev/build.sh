#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
