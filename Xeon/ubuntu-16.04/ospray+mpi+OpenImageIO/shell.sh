#!/bin/bash -e

IMAGE="xeon_ubuntu1604_ospray-oiio-mpi"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
