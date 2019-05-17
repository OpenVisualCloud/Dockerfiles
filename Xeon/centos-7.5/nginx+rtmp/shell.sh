#!/bin/bash -e

IMAGE="xeon-centos75-nginx-rtmp"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
