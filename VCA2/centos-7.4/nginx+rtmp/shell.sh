#!/bin/bash -e

IMAGE="vca2-centos74-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
