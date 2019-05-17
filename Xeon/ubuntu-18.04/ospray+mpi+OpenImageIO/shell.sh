#!/bin/bash -e

IMAGE="xeon-ubuntu1804_ospray-oiio-mpi"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
