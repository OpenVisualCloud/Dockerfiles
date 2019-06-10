#!/bin/bash -e

IMAGE="vca2-ubuntu1604-media-nginx"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
