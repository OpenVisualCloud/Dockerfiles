#!/bin/bash -e

IMAGE="xeon-ubuntu1604-media-svt"
VERSION="1.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
