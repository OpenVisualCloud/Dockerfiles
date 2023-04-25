#!/bin/bash -e

IMAGE="qat-ubuntu2204-media-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/qatshell.sh"
