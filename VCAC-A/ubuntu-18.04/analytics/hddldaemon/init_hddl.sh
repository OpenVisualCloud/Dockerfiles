#!/bin/bash

modprobe i2c-dev i2c-i801 i2c-hid
cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/drivers
bash setup.sh install

