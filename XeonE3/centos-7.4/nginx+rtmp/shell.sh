#!/bin/bash -e

IMAGE="xeone3-centos74-media-nginx"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
