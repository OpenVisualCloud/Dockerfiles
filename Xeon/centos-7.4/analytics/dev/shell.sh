#!/bin/bash -e

IMAGE="xeon-centos74-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
