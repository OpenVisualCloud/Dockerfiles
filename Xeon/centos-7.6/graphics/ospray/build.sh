#!/bin/bash -e

IMAGE="xeon-centos76-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
