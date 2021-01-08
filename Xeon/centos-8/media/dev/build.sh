#!/bin/bash -e

IMAGE="xeon-centos8-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
