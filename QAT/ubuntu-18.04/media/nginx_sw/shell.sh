#!/bin/bash -e

IMAGE="qat-ubuntu1804-media-nginx_sw"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatshell.sh"
