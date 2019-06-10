#!/bin/bash -e

IMAGE="vca2-ubuntu1804-media-nginx"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
