#!/bin/bash -e

if grep --quiet 'NAME="CentOS Linux"' /etc/os-release; then
  yum install -y -q wget
else
  apt-get update
  apt-get install -y wget 
fi

wget https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_v0.6.1.json
wget https://raw.githubusercontent.com/Netflix/vmaf_resource/master/python/test/resource/yuv/src01_hrc00_576x324.yuv
wget https://raw.githubusercontent.com/Netflix/vmaf_resource/master/python/test/resource/yuv/src01_hrc01_576x324.yuv

ffmpeg -video_size 576x324 -r 24 -pixel_format yuv420p -i src01_hrc00_576x324.yuv \
    -video_size 576x324 -r 24 -pixel_format yuv420p -i src01_hrc01_576x324.yuv \
    -lavfi "[0:v]setpts=PTS-STARTPTS[reference]; [1:v]setpts=PTS-STARTPTS[distorted]; \
    [distorted][reference]libvmaf=log_fmt=xml:log_path=/dev/stdout:model_path=vmaf_v0.6.1.json" \
    -f null -;
