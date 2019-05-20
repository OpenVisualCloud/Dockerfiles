#!/bin/bash -e

IMAGE="xeon-ubuntu1804--graphics-ospary-oiio-mpi"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
