#!/bin/bash -e

IMAGE="vca2-centos76-nginx-rtmp"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
