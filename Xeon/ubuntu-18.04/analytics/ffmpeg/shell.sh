#!/bin/bash -e

IMAGE="xeon-ubuntu1804-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
