#!/bin/bash -e

IMAGE="xeone3-ubuntu1804-analytics-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
