#!/bin/bash -e

IMAGE="xeon_ubuntu1804_ospray"
PREFIX="openvisualcloud"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
