#!/bin/bash -e

IMAGE="xeon-ubuntu1604-dldt-gst"
PREFIX="openvisualcloud"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
