#!/bin/bash -e

IMAGE="sg2-ubuntu2204-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
