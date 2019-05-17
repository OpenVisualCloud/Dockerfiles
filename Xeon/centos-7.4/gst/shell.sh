#!/bin/bash -e

IMAGE="xeon-centos74-media-media-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
