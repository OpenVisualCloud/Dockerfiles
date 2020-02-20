#!/bin/bash -e

IMAGE="vca2-centos75-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
