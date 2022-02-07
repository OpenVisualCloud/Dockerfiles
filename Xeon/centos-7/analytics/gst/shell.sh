#!/bin/bash -e

IMAGE="xeon-centos7-analytics-gst:21.6"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
