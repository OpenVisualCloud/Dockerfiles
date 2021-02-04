#!/bin/bash -e
if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

BUILD_VERSION="${1:-1.0}"
OS_NAME="${2:-ubuntu}"
OS_VERSION="${3:-18.04}"
BUILD_FDKAAC="${4:-ON}"
DOCKER_PREFIX="${5:-openvisualcloud}"
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/"
BUILD_CACHE=""
FULL_CACHE=""

if [[ ${DOCKER_PREFIX} == ovccache ]]; then
    BUILD_CACHE="--cache-from ${DOCKER_PREFIX}/${IMAGE}:build"
    FULL_CACHE="--cache-from ${DOCKER_PREFIX}/${IMAGE}:build --cache-from ${DOCKER_PREFIX}/${IMAGE}:latest"
fi

for m4file in "${DIR}"/*.m4; do
    if [[ -f $m4file ]]; then
        m4 -I "${SCRIPT_ROOT}/../template/system" -I "${SCRIPT_ROOT}/../template/components" -DOS_NAME=${OS_NAME} -DOS_VERSION=${OS_VERSION} -DBUILD_FDKAAC=${BUILD_FDKAAC} "${m4file}" > "${m4file%\.m4}"
    fi
done || true

if [[ $1 == -n ]]; then
    exit 0
fi

build_args=$(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/--build-arg /')
if grep -q 'AS build' "${DIR}/Dockerfile"; then
    docker build --network=host ${BUILD_CACHE} --target build -t "${DOCKER_PREFIX}/${IMAGE}:build" "$DIR" $build_args
fi

docker build --network=host ${FULL_CACHE} -t "${DOCKER_PREFIX}/${IMAGE}:${BUILD_VERSION}" -t "${DOCKER_PREFIX}/${IMAGE}:latest" "$DIR" $build_args
