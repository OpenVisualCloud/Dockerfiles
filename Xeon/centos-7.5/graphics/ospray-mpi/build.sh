#!/bin/bash -e

IMAGE="xeon-centos75-graphics-ospary-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
