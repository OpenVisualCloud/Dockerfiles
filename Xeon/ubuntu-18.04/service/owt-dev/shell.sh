#!/bin/bash -e

IMAGE="xeon-ubuntu1804-service-owt-dev"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
