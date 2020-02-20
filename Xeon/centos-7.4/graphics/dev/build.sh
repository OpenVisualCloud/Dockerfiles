#!/bin/bash -e

IMAGE="xeon-centos74-graphics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
