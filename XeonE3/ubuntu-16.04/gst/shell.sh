#!/bin/bash -e

IMAGE="xeone3-ubuntu1604-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
