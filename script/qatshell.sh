#!/bin/bash -e

if [[ -z $DIR ]]; then
    echo "This script should not be called directly."
    exit 1
fi

DEVICE_DIR="-v /dev/hugepages:/dev/hugepages -v /var/tmp:/var/tmp $(ls -1 /etc/*_dev?.conf | sed 's/\(.*\)/-v \1:\1/') $(ls -1 /dev/uio* /dev/qat_* /dev/usdm_drv | sed 's/\(.*\)/--device=\1:\1/')"
. "${DIR}/../../../../script/shell.sh"
