#!/bin/bash -e

IMAGE="vca2-ubuntu1804-media-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
