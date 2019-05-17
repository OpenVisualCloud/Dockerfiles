#!/bin/bash -e

IMAGE="xeon-centos76-analytics-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
