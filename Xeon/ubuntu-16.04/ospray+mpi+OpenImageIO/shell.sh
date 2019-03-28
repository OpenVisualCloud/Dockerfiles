#!/bin/bash -e

IMAGE="xeon_ubuntu1604_ospray-oiio-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
