#!/bin/bash -e

BUILD_LOG="$(pwd)/travis.log"

cd "$1" > ${BUILD_LOG} 2>&1 || exit 1
make >> ${BUILD_LOG} 2>&1 || exit 1
(ctest || ctest -V --rerun-failed) >> ${BUILD_LOG} 2>&1
