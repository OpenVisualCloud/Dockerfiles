#!/bin/bash -e

BUILD_LOG="$(pwd)/travis.log"

cd "$1" > ${BUILD_LOG} || exit 1
make >> ${BUILD_LOG} || exit 1
(ctest || ctest -V --rerun-failed) >> ${BUILD_LOG} 
