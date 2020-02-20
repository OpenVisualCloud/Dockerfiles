#!/bin/bash -e

IMAGE="qat-ubuntu1604-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
