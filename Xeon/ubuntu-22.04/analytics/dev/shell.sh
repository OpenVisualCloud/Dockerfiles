#!/bin/bash -e

IMAGE="xeon-ubuntu2204-analytics-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
