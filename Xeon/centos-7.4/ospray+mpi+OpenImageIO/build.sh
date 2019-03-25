#!/bin/bash -e

IMAGE="xeon_centos74_ospray-oiio-mpi"
VERSION="1.0"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
