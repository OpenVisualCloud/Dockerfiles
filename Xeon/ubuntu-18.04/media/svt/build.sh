#!/bin/bash -e

IMAGE="xeon-ubuntu1804-media-svt"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
