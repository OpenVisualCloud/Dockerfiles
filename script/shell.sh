#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

: "${DOCKER_PREFIX:=openvisualcloud}"

if [[ -d /dev/dri ]]; then
    DEVICE_DIR="--device=/dev/dri:/dev/dri $DEVICE_DIR"
fi

if [[ -z $TRAVIS && -z $JENKINS_URL ]]; then DOCKER_IT="-it"; else DOCKER_IT=""; fi

TEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/../test/"

if [[ $IMAGE == *analytics* ]] || [[ $IMAGE == *nginx* ]]; then
    HOST_NETWORK="--network=host $HOST_NETWORK"
fi

docker run $DEVICE_DIR --rm $HOST_NETWORK -v "${TEST}:/mnt:rw" $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/-e /') $(grep '^ARG .*=' "${DIR}/Dockerfile" | sed 's/^ARG \([^=]*\)=.*/-e \1/') $DOCKER_IT "${DOCKER_PREFIX}/${IMAGE}" "${@:-/bin/bash}"
