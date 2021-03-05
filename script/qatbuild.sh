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

for m4file in "${DIR}"/*.m4; do
    if [[ -f $m4file ]]; then
        m4 "-I${DIR}/../../../../template/components" "-I${DIR}/../../../../template/system" -DDOCKER_IMAGE=${IMAGE} -DBUILD_FDKAAC=${BUILD_FDKAAC} -DOS_NAME=${OS_NAME} -DOS_VERSION=${OS_VERSION} -DBUILD_VERSION=${BUILD_VERSION} "${m4file}" > "${m4file%\.m4}"
    fi
done || true

if [[ $1 == -n ]]; then
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
