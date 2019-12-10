#!/bin/bash -e

IMAGE="xeone3-centos76-media-nginx"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
