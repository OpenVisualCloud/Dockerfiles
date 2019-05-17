#!/bin/bash -e

IMAGE="xeon_ubuntu1804_ospray"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
