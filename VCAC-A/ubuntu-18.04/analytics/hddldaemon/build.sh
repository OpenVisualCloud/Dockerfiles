#!/bin/bash -e

IMAGE="vcaca-ubuntu1804-analytics-hddldaemon"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
