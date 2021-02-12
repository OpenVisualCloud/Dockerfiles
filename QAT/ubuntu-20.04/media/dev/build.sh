#!/bin/bash -e

IMAGE="qat-ubuntu1804-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
