#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

if test -d /opt/intel/QAT; then
    DEVICE_DIR="$(ls -1 -d /etc/*_dev?.conf /dev/hugepages | sed 's/\(.*\)/-v \1:\1/') $(ls -1 /dev/uio* /dev/qat_* /dev/usdm_drv | sed 's/\(.*\)/--device=\1:\1/')"
    . "${DIR}/../../../../script/shell.sh"
else
    echo "Shell must run on a Intel QAT platform"
fi
