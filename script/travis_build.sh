#!/bin/bash -e

BUILD_NAME=$1
BUILD_ROOT=`pwd`
BIULD_LOG=${BUILD_ROOT}/travis.log

echo "Building $BUILD_NAME"
cd "$1" || exit 1
make >> $BUILD_LOG 2>&1|| exit 1
ctest >> $BUILD_LOG 2>&1 || ctest -V >> $BUILD_LOG 2>&1
