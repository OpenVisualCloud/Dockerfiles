#!/bin/bash -e

IMAGE="owt_ubuntu1804"
VERSION="4.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
