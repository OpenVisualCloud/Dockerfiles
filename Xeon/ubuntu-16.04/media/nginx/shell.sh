#!/bin/bash -e

IMAGE="xeon-ubuntu1604-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
