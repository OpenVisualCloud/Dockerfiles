#!/bin/bash -e

IMAGE="flex-ubuntu2204-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
