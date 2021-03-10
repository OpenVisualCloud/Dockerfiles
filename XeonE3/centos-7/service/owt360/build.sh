#!/bin/bash -e

IMAGE="xeone3-centos7-service-owt360"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
