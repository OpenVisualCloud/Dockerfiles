#!/bin/bash -e

IMAGE="vca2-ubuntu1604-dev"
PREFIX="openvisualcloud"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/shell.sh"
