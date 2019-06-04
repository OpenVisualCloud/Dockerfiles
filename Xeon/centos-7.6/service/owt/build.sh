#!/bin/bash -e

IMAGE="xeon-centos76-service-owt"
VERSION="4.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
