#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-nginx-rtmp"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
