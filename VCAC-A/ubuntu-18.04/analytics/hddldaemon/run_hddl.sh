#!/bin/bash

while [ ! -c /dev/ion ] ; do
	echo "waiting for myd_ion to be ready"
	sleep 1
done

source /opt/intel/hddl/bin/setupvars.sh
cd /opt/intel/hddl/deployment_tools/inference_engine/external/hddl/bin
./hddldaemon
