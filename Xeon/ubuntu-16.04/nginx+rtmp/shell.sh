#!/bin/bash -e

IMAGE="xeon-ubuntu1604-nginx-rtmp"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
