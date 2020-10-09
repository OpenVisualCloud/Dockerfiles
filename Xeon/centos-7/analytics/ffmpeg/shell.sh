#!/bin/bash -e

IMAGE="xeon-centos7-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
