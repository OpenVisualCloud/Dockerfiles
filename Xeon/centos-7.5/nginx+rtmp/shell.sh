#!/bin/bash -e

IMAGE="xeon-centos75-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
