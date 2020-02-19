#!/bin/bash -e

IMAGE="xeon-centos75-graphics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
