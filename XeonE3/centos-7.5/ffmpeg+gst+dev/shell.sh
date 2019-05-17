#!/bin/bash -e

IMAGE="xeone3-centos75-dev"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
