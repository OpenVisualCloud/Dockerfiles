#!/bin/bash -e

IMAGE="xeon-centos75-dldt-ffmpeg"
PREFIX="openvisualcloud"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
