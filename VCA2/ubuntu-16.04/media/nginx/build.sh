#!/bin/bash -e

IMAGE="vca2-ubuntu1604-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
