#!/bin/bash -e

IMAGE="vca2-centos76-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
