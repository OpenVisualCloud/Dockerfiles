#!/bin/bash -e

IMAGE="xeon-ubuntu1804-analytics-dev"
VERSION="20.2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
