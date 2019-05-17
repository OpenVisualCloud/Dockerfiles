#!/bin/bash -e

IMAGE="xeon_centos75_ospray"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
