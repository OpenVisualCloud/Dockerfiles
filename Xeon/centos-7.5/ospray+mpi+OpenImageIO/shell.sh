#!/bin/bash -e

IMAGE="xeon-centos75_ospray-oiio-mpi"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
