#!/bin/bash -e

IMAGE="xeon-ubuntu2004-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
