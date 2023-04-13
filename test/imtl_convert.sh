#!/bin/bash -e

sysctl -w vm.nr_hugepages=4096
apt update
apt install -y wget ffmpeg
cd /home/imtl/app
wget --no-check-certificate https://www.larmoire.info/jellyfish/media/jellyfish-3-mbps-hd-hevc-10bit.mkv
ffmpeg -i jellyfish-3-mbps-hd-hevc-10bit.mkv -vframes 2 -c:v rawvideo yuv420p10le_1080p.yuv
ffmpeg -s 1920x1080 -pix_fmt yuv420p10le -i yuv420p10le_1080p.yuv -pix_fmt yuv422p10le yuv422p10le_1080p.yuv
./ConvApp -width 1920 -height 1080 -in_pix_fmt yuv422p10le -i yuv422p10le_1080p.yuv -out_pix_fmt yuv422rfc4175be10 -o yuv422rfc4175be10_1080p.yuv
