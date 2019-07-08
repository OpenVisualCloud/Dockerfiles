#!/bin/bash -e

IMAGE="xeon-ubuntu1804-service-owt"
VERSION="1.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
