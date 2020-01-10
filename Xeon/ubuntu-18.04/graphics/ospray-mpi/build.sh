#!/bin/bash -e

IMAGE="xeon-ubuntu1804-graphics-ospary-mpi"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
