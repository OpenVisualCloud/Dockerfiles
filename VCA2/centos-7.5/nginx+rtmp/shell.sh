#!/bin/bash -e

IMAGE="vca2-centos75-nginx-rtmp"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
