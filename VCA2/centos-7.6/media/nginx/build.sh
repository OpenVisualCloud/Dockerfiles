#!/bin/bash -e

IMAGE="vca2-centos76-media-nginx"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
