#!/bin/bash -e

IMAGE="xeon-centos75-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
