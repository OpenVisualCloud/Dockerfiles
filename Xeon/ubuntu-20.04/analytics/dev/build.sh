#!/bin/bash -e

IMAGE="xeon-ubuntu2004-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
