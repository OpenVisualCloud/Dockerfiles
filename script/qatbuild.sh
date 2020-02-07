#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

if test -d /opt/intel/QAT; then
   if test ! -f "${DIR}/qat.tar.gz"; then
       sudo tar cfz "${DIR}/qat.tar.gz" /opt/intel/QAT/build $(find /opt/intel/QAT -name "*.h") /etc/udev/rules.d/00-qat.rules --exclude /opt/intel/QAT/*.tar.gz
   fi
   export QAT_GID_VER=$(getent group qat | cut -f3 -d:)
   . "${DIR}/../../../../script/build.sh"
fi
