#!/bin/bash -e
if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

BUILD_VERSION="${1:-1.0}"
BUILD_MP3LAME="${2:-ON}"
BUILD_FDKAAC="${3:-ON}"
UPDATE_DOCKERFILES="${4:-OFF}"
UPDATE_DOCKERHUB_README="${5:-OFF}"
DOCKER_PREFIX="${6:-openvisualcloud}"
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/"
BUILD_CACHE=""
FULL_CACHE=""

if [[ ${DOCKER_PREFIX} == ovccache ]]; then
    BUILD_CACHE="--cache-from ${DOCKER_PREFIX}/${IMAGE}:build"
    FULL_CACHE="--cache-from ${DOCKER_PREFIX}/${IMAGE}:build --cache-from ${DOCKER_PREFIX}/${IMAGE}:latest"
fi

for m4file in "${DIR}"/*.m4; do
    if [[ -f $m4file ]]; then
        m4 "-I${SCRIPT_ROOT}/../template/" -DDOCKER_IMAGE=${IMAGE} -DBUILD_MP3LAME=${BUILD_MP3LAME} -DBUILD_FDKAAC=${BUILD_FDKAAC} "${m4file}" > "${m4file%\.m4}"
    fi
done || true

if [[ $1 == -n ]]; then
    exit 0
fi

if [[ ${UPDATE_DOCKERFILES} == OFF ]]; then
    build_args=$(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/--build-arg /')
    if grep -q 'AS build' "${DIR}/Dockerfile"; then
        sudo -E docker build --network=host ${BUILD_CACHE} --target build -t "${DOCKER_PREFIX}/${IMAGE}:build" "$DIR" $build_args
    fi

    sudo -E docker build --network=host ${FULL_CACHE} -t "${DOCKER_PREFIX}/${IMAGE}:${BUILD_VERSION}" -t "${DOCKER_PREFIX}/${IMAGE}:latest" "$DIR" $build_args
elif [[ ${UPDATE_DOCKERHUB_README} == ON ]]; then
    README_FILEPATH="$(echo "$PWD/README.md" | sed 's/build\///')"
    ${SCRIPT_ROOT}/update-dockerhub-readme.sh ${DOCKER_PREFIX} ${IMAGE} ${README_FILEPATH}
fi
