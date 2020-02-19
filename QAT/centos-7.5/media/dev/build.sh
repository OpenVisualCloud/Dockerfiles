#!/bin/bash -e

IMAGE="qat-centos75-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
