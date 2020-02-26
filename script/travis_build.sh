#!/bin/bash -e

BUILD_NAME=$1

cd "$BUILD_NAME" || exit 1
make || exit 1
ctest || ctest -V --rerun-failed
