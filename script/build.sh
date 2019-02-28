#!/bin/bash -e

if test -z "${DIR}"; then 
    echo "This script should not be called directly."
    exit -1
fi 

TEMPLATE="${DIR}/../../../template"

for m4file in "${DIR}"/*.m4; do
    if test -f "$m4file"; then
       m4 "-I${TEMPLATE}" -DDOCKER_IMAGE=${IMAGE} "${m4file}" > "${m4file%\.m4}"
    fi
done || echo

if test "$1" = '-n'; then 
    exit 0; 
fi

if grep -q 'AS build' "${DIR}/Dockerfile"; then
    docker build --network=host --target build -t "${IMAGE}:build" "$DIR" $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/--build-arg /')
fi

docker build --network=host -t "${IMAGE}:${VERSION}" -t "${IMAGE}:latest" "$DIR" $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/--build-arg /')
