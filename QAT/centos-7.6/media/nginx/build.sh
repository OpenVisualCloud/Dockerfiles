#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

if test -d /opt/intel/QAT; then
   if test ! -f "${DIR}/qat-driver.tar.gz"; then
       sudo tar cfz "${DIR}/qat-driver.tar.gz" /opt/intel/QAT
   fi
   . "${DIR}/../../../../script/build.sh"
fi
