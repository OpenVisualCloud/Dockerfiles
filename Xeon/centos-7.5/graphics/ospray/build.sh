#!/bin/bash -e

IMAGE="xeon-centos75-graphics-ospray"
VERSION="1.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
