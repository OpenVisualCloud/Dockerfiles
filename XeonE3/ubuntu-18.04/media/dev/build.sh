#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
