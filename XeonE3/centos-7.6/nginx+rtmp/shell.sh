#!/bin/bash -e

IMAGE="xeone3-centos76-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
