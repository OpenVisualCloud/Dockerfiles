#!/bin/bash -e

IMAGE="vca2-centos74-gst"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
