#!/bin/bash -e

cd "$1" || exit 1
BUILD_NAME=$1

echo "Building $BUILD_NAME"

BUILD_NAME=$(sed 's/[\/+]/_/g' <<< $BUILD_NAME)
BUILD_NAME=$(sed 's/[\.\-]//g' <<< $BUILD_NAME)

make >> /home/travis/travis.log
ctest >> /home/travis//travis.log 
