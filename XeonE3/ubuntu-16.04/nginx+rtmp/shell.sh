#!/bin/bash -e

IMAGE="xeone3-ubuntu1604-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
