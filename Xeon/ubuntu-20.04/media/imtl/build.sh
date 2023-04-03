#!/bin/bash -e

IMAGE="xeon-ubuntu2004-media-imtl"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
