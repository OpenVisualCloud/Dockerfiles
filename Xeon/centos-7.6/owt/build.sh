#!/bin/bash -e

IMAGE="owt_centos76"
VERSION="4.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
