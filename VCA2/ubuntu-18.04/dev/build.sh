#!/bin/bash -e

IMAGE="vca2-ubuntu1804-dev"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../script/build.sh"
