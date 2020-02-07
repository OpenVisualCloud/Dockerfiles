#!/bin/bash -e

IMAGE="xeon-centos74-graphics-dev"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
