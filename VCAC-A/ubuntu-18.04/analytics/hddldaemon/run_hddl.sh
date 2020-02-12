#!/bin/bash

mount -t devtmpfs none /dev
while [ ! -c /dev/ion ] ; 
    do sleep 1; 
done
modprobe i2c-i801 i2c-dev i2c-hid myd_ion

source /opt/intel/openvino/bin/setupvars.sh
cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin
./hddldaemon

