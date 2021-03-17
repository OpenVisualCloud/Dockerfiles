#!/bin/bash -e

IMAGE="xeon-ubuntu1804-graphics-ospray-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
