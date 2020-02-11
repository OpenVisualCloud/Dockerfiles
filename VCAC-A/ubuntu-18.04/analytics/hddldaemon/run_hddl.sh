#!/bin/bash

while [ ! -c /dev/ion ] ; 
    do sleep 1; 
done

source /opt/intel/openvino/bin/setupvars.sh
cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin
while true; do 
    ./hddldaemon; 
    sleep 1; 
done

