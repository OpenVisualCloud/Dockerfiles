#!/bin/bash -e

if test -z "${DIR}"; then
    echo "This script should not be called directly."
    exit -1
fi

PREFIX="${PREFIX:-openvisualcloud}"

if [ -d "/dev/dri" ]; then
    DEVICE_DIR=--device=/dev/dri:/dev/dri
fi

if [ -z "$TRAVIS" ] && [ -z "$JENKINS_URL" ]; then DOCKER_IT="-it"; else DOCKER_IT=""; fi

if echo ${IMAGE} | grep -q "dev"; then
    TEST="${DIR}/../../../test/"
else
    TEST="${DIR}/../../../../test/"
fi

sudo docker run $DEVICE_DIR --rm -v "${TEST}:/mnt:ro" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/-e /') $(grep '^ARG .*=' "${DIR}/Dockerfile" | sed 's/^ARG \([^=]*\)=.*/-e \1/') $DOCKER_IT "${PREFIX}/${IMAGE}" ${*-/bin/bash}


