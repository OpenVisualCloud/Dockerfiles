#!/bin/bash -e

IMAGE="xeon-centos76-graphics-ospray-oiio-mpi"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
