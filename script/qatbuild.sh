#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
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
