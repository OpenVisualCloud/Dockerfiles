#!/bin/bash -e
if test -z "${DIR}"; then 
    echo "This script should not be called directly."
    exit -1
fi 

SECURITY_STRICT="${1:-No}"

if echo ${IMAGE} | grep -q "dev"; then
    TEMPLATE="${DIR}/../../../template/"
else
    TEMPLATE="${DIR}/../../../../template/"
fi

PREFIX="${PREFIX:-openvisualcloud}"

for m4file in "${DIR}"/*.m4; do
    if test -f "$m4file"; then
       m4 "-I${TEMPLATE}" -DDOCKER_IMAGE=${IMAGE} -DSECURITY_STRICT=${SECURITY_STRICT} "${m4file}" > "${m4file%\.m4}"
    fi
done || echo

if test "$1" = '-n'; then 
    exit 0; 
fi

if grep -q 'AS build' "${DIR}/Dockerfile"; then
    sudo docker build --target build -t "${PREFIX}/${IMAGE}:build" "$DIR" $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/--build-arg /')
fi

sudo docker build -t "${PREFIX}/${IMAGE}:${VERSION}" -t "${PREFIX}/${IMAGE}:latest" "$DIR" $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/--build-arg /')
