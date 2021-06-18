#!/bin/bash -e

IMAGE="qat-centos7-media-nginx_sw"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
