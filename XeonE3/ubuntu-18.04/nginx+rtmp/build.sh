#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-nginx-rtmp"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
