#!/bin/bash -e

IMAGE="vca2-centos76-media-nginx"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
