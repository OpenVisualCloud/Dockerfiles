#!/bin/bash -e

IMAGE="xeon-centos76-media-svt"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
