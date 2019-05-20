#!/bin/bash -e

IMAGE="xeon-centos76-graphics-ospary-oiio-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
