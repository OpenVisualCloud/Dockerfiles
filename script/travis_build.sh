#!/bin/bash -e

echo "where are we" && pwd
cd "$1" || exit 1
BUILD_NAME=$1
BIULD_LOG=/home/travis/travis.log
echo "Building $BUILD_NAME"

BUILD_NAME=$(sed 's/[\/+]/_/g' <<< $BUILD_NAME)
BUILD_NAME=$(sed 's/[\.\-]//g' <<< $BUILD_NAME)

make >> $BUILD_LOG 2>&1|| exit 1
ctest >> $BUILD_LOG 2>&1 || ctest -V >> $BUILD_LOG 2>&1
