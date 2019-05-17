#!/bin/bash -e

IMAGE="xeon-ubuntu1804-media-nginx"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
