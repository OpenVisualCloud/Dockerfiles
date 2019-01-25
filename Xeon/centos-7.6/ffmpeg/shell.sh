#!/bin/bash -e

IMAGE="xeon-centos76-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
