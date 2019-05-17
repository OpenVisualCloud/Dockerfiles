#!/bin/bash -e

IMAGE="xeone3-centos74-analytics-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
