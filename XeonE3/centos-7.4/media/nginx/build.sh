#!/bin/bash -e

IMAGE="xeone3-centos74-media-nginx"
VERSION="1.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
