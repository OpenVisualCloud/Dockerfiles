#!/bin/bash -e

bus=($(dpdk-devbind.py -s | grep E810 | awk '{print $1}'))
if [[ -z $bus ]]
then
    echo "Can't detected E810 Network device!"
    exit -1
fi

apt update
apt install -y wget ffmpeg
cd /home/imtl/app
wget --no-check-certificate https://www.larmoire.info/jellyfish/media/jellyfish-3-mbps-hd-hevc-10bit.mkv
ffmpeg -i jellyfish-3-mbps-hd-hevc-10bit.mkv -vframes 2 -c:v rawvideo yuv420p10le_1080p.yuv
ffmpeg -s 1920x1080 -pix_fmt yuv420p10le -i yuv420p10le_1080p.yuv -pix_fmt yuv422p10le yuv422p10le_1080p.yuv
./ConvApp -width 1920 -height 1080 -in_pix_fmt yuv422p10le -i yuv422p10le_1080p.yuv -out_pix_fmt yuv422rfc4175be10 -o test.yuv
modprobe vfio-pci
dpdk-devbind.py -b vfio-pci ${bus[0]}
dpdk-devbind.py -b vfio-pci ${bus[1]}
sysctl -w vm.nr_hugepages=4096
sed -i 's/0000:af:00.0/'${bus[0]}'/g' config/test_tx_1port_1v.json
sed -i 's/0000:af:00.1/'${bus[1]}'/g' config/test_rx_1port_1v.json
./RxTxApp --config_file config/test_rx_1port_1v.json --test_time 60 & ./RxTxApp --config_file config/test_tx_1port_1v.json --test_time 60
