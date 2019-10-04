#!/bin/bash -e

IMAGE="xeon-centos76-graphics-ospray"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
