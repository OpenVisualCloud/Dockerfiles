#!/bin/bash -e

IMAGE="xeon-centos74-analytics-ffmpeg"
PREFIX="openvisualcloud"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
