#!/bin/bash -e

BUILD_NAME=$1
BUILD_ROOT=`pwd`
BUILD_LOG=${BUILD_ROOT}/travis.log

echo BUILD_ROOT=${BUILD_ROOT}
echo BUILD_LOG=${BUILD_LOG}
cd "$BUILD_NAME" > ${BUILD_LOG} || exit 1
make >> ${BUILD_LOG} || exit 1
ctest >> ${BUILD_LOG} || ctest -V --rerun-failed >> ${BUILD_LOG}
