#!/bin/bash -e

IMAGE="xeone3-centos75-analytics-dev"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
