#!/bin/bash -e

if test -z "${DIR}"; then
    echo "This script should not be called directly."
    exit -1
fi

if [ -d "/dev/dri" ]; then
    DEVICE_DIR=--device=/dev/dri:/dev/dri
fi

sudo docker run $DEVICE_DIR --network=host -v "$DIR/../../../test:/mnt:ro" $(env | grep -E '_(proxy|REPO|VER)=' | sed 's/^/-e /') $(grep '^ARG .*=' "${DIR}/Dockerfile" | sed 's/^ARG /-e /') -it "${IMAGE}" ${*-/bin/bash}

