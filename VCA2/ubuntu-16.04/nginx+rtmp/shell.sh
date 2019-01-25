#!/bin/bash -e

IMAGE="vca2-ubuntu1604-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
