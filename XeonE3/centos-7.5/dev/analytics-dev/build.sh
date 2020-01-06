#!/bin/bash -e

IMAGE="xeone3-centos75-analytics-dev"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
