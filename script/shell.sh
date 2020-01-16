#!/bin/bash -e

if test -z "${DIR}"; then
    echo "This script should not be called directly."
    exit -1
fi

DOCKER_PREFIX="${DOCKER_PREFIX:-openvisualcloud}"

if [ -d "/dev/dri" ]; then
    DEVICE_DIR=--device=/dev/dri:/dev/dri
fi

if [ -z "$TRAVIS" ] && [ -z "$JENKINS_URL" ]; then DOCKER_IT="-it"; else DOCKER_IT=""; fi

TEST="${DIR}/../../../../test/"

if echo ${IMAGE} | grep -q "vcaca"; then
    sudo -E docker run $DEVICE_DIR --rm --user root --privileged -v /var/tmp:/var/tmp -v "${TEST}:/mnt:ro" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/-e /') $(grep '^ARG .*=' "${DIR}/Dockerfile" | sed 's/^ARG \([^=]*\)=.*/-e \1/') $DOCKER_IT "${DOCKER_PREFIX}/${IMAGE}" ${*-/bin/bash}
else
    sudo -E docker run $DEVICE_DIR --rm -v "${TEST}:/mnt:ro" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/-e /') $(grep '^ARG .*=' "${DIR}/Dockerfile" | sed 's/^ARG \([^=]*\)=.*/-e \1/') $DOCKER_IT "${DOCKER_PREFIX}/${IMAGE}" ${*-/bin/bash}
fi

