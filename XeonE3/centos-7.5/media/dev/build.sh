#!/bin/bash -e

IMAGE="xeone3-centos75-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
