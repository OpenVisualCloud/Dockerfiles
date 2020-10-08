#!/bin/bash -e

IMAGE="xeon-centos7-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
