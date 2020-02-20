#!/bin/bash -e

IMAGE="vca2-centos74-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
