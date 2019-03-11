#!/bin/bash -e

IMAGE="xeon-centos76-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
