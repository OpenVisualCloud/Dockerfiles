#!/bin/bash -e

IMAGE="xeon-centos75-analytics-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
