#!/bin/bash -e

IMAGE="qat-centos75-media-dev"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
