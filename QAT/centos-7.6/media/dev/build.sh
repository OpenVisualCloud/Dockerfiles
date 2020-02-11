#!/bin/bash -e

IMAGE="qat-centos76-media-dev"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatbuild.sh"
