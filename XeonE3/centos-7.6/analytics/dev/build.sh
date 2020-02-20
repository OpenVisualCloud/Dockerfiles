#!/bin/bash -e

IMAGE="xeone3-centos76-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
