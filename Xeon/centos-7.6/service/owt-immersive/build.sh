#!/bin/bash -e

IMAGE="xeon-centos76-service-owt-immersive"
VERSION="19.11"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
