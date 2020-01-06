#!/bin/bash -e

IMAGE="xeone3-centos76-service-owt-dev"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
