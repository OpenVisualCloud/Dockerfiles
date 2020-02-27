#!/bin/bash

modprobe -a i2c-dev i2c-i801 i2c-hid myd_ion myd_vsc
if [ ! -c /dev/ion ]; then
   cd /opt/intel/hddl/deployment_tools/inference_engine/external/hddl/drivers
   bash setup.sh install
fi
