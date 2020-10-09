#!/bin/bash -e

IMAGE="qat-centos7-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
