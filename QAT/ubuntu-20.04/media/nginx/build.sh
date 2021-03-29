#!/bin/bash -e

IMAGE="qat-ubuntu2004-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
