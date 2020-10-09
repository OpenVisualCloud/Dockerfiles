#!/bin/bash -e

IMAGE="xeon-centos7-graphics-ospary-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
