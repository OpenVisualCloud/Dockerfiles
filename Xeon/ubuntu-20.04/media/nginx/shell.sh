#!/bin/bash -e

IMAGE="xeon-ubuntu2004-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
