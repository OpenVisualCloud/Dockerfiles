#!/bin/bash -e

IMAGE="xeon-centos75-graphics-ospray"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
