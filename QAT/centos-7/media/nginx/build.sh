#!/bin/bash -e

IMAGE="qat-centos7-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
