#!/bin/bash -e
if test -z "${DIR}"; then 
    echo "This script should not be called directly."
    exit -1
fi 

BUILD_MP3LAME="${1:-ON}"
BUILD_FDKAAC="${2:-ON}"
ONLY_DOCKERFILES="${3:-OFF}"
DOCKER_PREFIX="${4:-openvisualcloud}"
TEMPLATE="${DIR}/../../../../template/"


for m4file in "${DIR}"/*.m4; do
    if test -f "$m4file"; then
       m4 "-I${TEMPLATE}" -DDOCKER_IMAGE=${IMAGE} -DBUILD_MP3LAME=${BUILD_MP3LAME} -DBUILD_FDKAAC=${BUILD_FDKAAC} "${m4file}" > "${m4file%\.m4}"
    fi
done || echo

if test "$1" = '-n'; then 
    exit 0; 
fi

if test "${ONLY_DOCKERFILES}" = 'OFF'; then
  if grep -q 'AS build' "${DIR}/Dockerfile"; then
      sudo docker build --network=host --target build -t "${DOCKER_PREFIX}/${IMAGE}:build" "$DIR" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/--build-arg /')
  fi

  sudo docker build --network=host -t "${DOCKER_PREFIX}/${IMAGE}:${VERSION}" -t "${DOCKER_PREFIX}/${IMAGE}:latest" "$DIR" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/--build-arg /')
fi
