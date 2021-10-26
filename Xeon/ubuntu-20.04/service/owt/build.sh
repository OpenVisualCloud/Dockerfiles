#!/bin/bash -e

IMAGE="xeon-ubuntu2004-service-owt"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
