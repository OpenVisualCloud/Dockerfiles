#!/bin/bash -e

IMAGE="qat-centos74-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatshell.sh"
