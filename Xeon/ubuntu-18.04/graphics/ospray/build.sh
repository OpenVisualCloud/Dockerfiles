#!/bin/bash -e

IMAGE="xeon-ubuntu1804-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
