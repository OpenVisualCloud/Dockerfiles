#!/bin/bash -e

bus=($(dpdk-devbind.py -s | grep E810 | awk '{print $1}'))
if [[ -z $bus ]]
then
    echo "Can't detected E810 Network device!"
    exit -1
fi

modprobe vfio-pci
sysctl -w vm.nr_hugepages=4096
dpdk-devbind.py -b ice ${bus[0]}
dpdk-devbind.py -b ice ${bus[1]}
dpdk-devbind.py -b vfio-pci ${bus[0]}
dpdk-devbind.py -b vfio-pci ${bus[1]}
/home/imtl/tests/KahawaiTest --p_port ${bus[0]} --r_port ${bus[1]}
