#!/bin/bash -e

IMAGE="xeone3-centos74-nginx-rtmp"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
