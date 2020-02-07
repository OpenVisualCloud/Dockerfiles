#!/bin/bash -e

IMAGE="qat-centos76-media-nginx"
VERSION="20.1"
DIR=$(dirname $(readlink -f "$0"))

if test \( -d /opt/intel/QAT \) -a \( -d /opt/intel/QATzip \); then
   if test ! -f "${DIR}/qat-qatzip.tar.gz"; then
       sudo tar cfz "${DIR}/qat-qatzip.tar.gz" /opt/intel/QAT /etc/udev/rules.d/00-qat.rules /usr/lib64/libqat_s.so /usr/lib64/libusdm_drv_s.so /opt/intel/QATzip /etc/c6xx_dev?.conf /etc/dh895xcc_dev?.conf /usr/lib64/libqatzip.so /usr/bin/qzip
   fi
   . "${DIR}/../../../../script/build.sh"
fi
