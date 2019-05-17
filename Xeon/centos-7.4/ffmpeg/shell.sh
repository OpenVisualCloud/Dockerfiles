#!/bin/bash -e

IMAGE="xeon-centos74-mediaffmpeg"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
