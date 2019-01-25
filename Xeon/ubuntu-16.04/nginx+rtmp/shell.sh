#!/bin/bash -e

IMAGE="xeon-ubuntu1604-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
