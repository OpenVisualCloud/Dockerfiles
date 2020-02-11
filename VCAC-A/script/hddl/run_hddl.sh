#!/bin/bash

if [ "$1" == "init" ]; then
    modprobe i2c-dev i2c-i801 i2c-hid
    cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/drivers
    bash setup.sh install
    while true; do sleep 3600; done
else
    while [ ! -c /dev/ion ] ; do sleep 1; done
    source /opt/intel/openvino/bin/setupvars.sh
    cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin
    while true; do ./hddldaemon; sleep 1; done
fi

