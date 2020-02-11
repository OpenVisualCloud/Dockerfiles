#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatshell.sh"
