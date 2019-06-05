#!/bin/bash -e

IMAGE="xeon-centos75-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
