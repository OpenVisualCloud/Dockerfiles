#!/bin/bash -e

IMAGE="xeon-ubuntu2204-analytics-ffmpeg"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
