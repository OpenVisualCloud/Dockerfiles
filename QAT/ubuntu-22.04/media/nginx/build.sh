#!/bin/bash -e

IMAGE="qat-ubuntu2204-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
