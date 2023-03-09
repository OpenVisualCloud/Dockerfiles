#!/bin/bash -e

IMAGE="xeon-ubuntu2204-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
