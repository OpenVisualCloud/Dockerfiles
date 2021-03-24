#!/bin/bash -e

IMAGE="xeon-centos7-graphics-ospray-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
