#!/bin/bash -e

BUILD_NAME=$1
BUILD_ROOT=`pwd`
BUILD_LOG=${BUILD_ROOT}/travis.log
echo "BUILD_LOG=$BUILD_LOG"
echo "Building $BUILD_NAME"
cd "$1" || exit 1
make >> $BUILD_LOG || exit 1
ctest >> $BUILD_LOG || ctest -V >> $BUILD_LOG 
