#!/bin/bash -e

IMAGE="xeon-centos76-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
