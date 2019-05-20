#!/bin/bash -e

IMAGE="xeon-ubuntu1604-graphics-ospray"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
