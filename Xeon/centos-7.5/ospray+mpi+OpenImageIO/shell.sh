#!/bin/bash -e

IMAGE="xeon_centos75_ospray-oiio-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
