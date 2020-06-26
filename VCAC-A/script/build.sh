#!/bin/bash -e

DIR=$(dirname $(readlink -f "$0"))
BUILD_VERSION=${1:-1.0}

for file1 in "$DIR"/*.m4; do 
    target1="${file1%\.m4}"
    m4 -DBUILD_VERSION=${BUILD_VERSION} "$file1" > "$target1"
    case "$target1" in
    *.sh*)
        chmod a+rx "$target1";;
    esac
done
