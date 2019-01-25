#!/bin/bash -e

IMAGE="xeon-centos74-dldt-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
