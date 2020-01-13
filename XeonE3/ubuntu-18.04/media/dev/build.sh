#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-media-dev"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
