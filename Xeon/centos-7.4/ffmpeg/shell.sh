#!/bin/bash -e

IMAGE="xeon-centos74-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
