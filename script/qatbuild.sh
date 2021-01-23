#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

if [[ $1 == -n ]]; then
    BUILD_FDKAAC="${2:-ON}"
    DOCKER_PREFIX="${3:-openvisualcloud}"
    SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/"

    for m4file in "${DIR}"/*.m4; do
        if [[ -f $m4file ]]; then
            m4 "-I${SCRIPT_ROOT}/../template/" -DDOCKER_IMAGE=${IMAGE} -DBUILD_FDKAAC=${BUILD_FDKAAC} "${m4file}" > "${m4file%\.m4}"
        fi
    done || true
    exit 0
fi

if test -d /opt/intel/QAT; then
   if test ! -f "${DIR}/qat.tar.gz"; then
       docker run --rm -v /opt/intel/QAT:/opt/intel/QAT:ro -v /etc/udev:/etc/udev:ro -v "${DIR}:/home:rw" -it busybox /bin/sh -c "tar cfz /home/qat.tar.gz /opt/intel/QAT/build \$(find /opt/intel/QAT -name '*.h') /etc/udev/rules.d/00-qat.rules --exclude /opt/intel/QAT/*.tar.gz && chown $(id -u).$(id -g) /home/qat.tar.gz"
   fi
   export QAT_GID_VER=$(getent group qat | cut -f3 -d:)
   . "${DIR}/../../../../script/build.sh"
else 
   echo "Build must run on an Intel QAT platform."
fi
