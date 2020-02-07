#!/bin/bash -e

IMAGE="vca2-ubuntu1804-media-dev"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
