#!/bin/bash -e

IMAGE="xeon-centos74--graphics-ospary-oiio-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
