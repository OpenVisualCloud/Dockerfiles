#!/bin/bash -e

IMAGE="xeon-ubuntu1804-service-owt"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
