#!/bin/bash -e

IMAGE="xeon_centos75_ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
