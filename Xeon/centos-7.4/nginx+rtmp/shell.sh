#!/bin/bash -e

IMAGE="xeon-centos74-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
