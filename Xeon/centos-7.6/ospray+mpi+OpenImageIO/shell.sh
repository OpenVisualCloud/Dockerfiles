#!/bin/bash -e

IMAGE="xeon-centos76-graphics-graphics-ospary-oiio-mpi"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
