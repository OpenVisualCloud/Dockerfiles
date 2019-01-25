#!/bin/bash -e

IMAGE="xeon-centos76-dldt-gst"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
