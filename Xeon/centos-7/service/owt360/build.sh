#!/bin/bash -e

IMAGE="xeon-centos7-service-owt360"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
