#!/bin/bash -e

if grep --quiet 'NAME="CentOS Linux"' /etc/os-release; then
  yum install -y centos-release-scl wget
  yum install -y rh-python36
  source /opt/rh/rh-python36/enable
else
  apt-get update
  apt-get install -y wget make python3 python3-pip
  if grep --quiet 'Ubuntu 18' /etc/os-release; then
    apt-get install -y libjson-c3
  fi
fi

pip3 install pyyaml requests

if grep --quiet 'Ubuntu 18' /etc/os-release; then
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-license-plate-detection-barrier-0106/FP16/vehicle-license-plate-detection-barrier-0106.xml
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-license-plate-detection-barrier-0106/FP16/vehicle-license-plate-detection-barrier-0106.bin
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-attributes-recognition-barrier-0039/FP16/vehicle-attributes-recognition-barrier-0039.bin
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-attributes-recognition-barrier-0039/FP16/vehicle-attributes-recognition-barrier-0039.xml

  dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
  ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libx264 -y test.mp4
  ffmpeg -i test.mp4 -vf \
    "detect=model=vehicle-license-plate-detection-barrier-0106.xml:device=HDDL, \
     classify=model=vehicle-attributes-recognition-barrier-0039.xml:device=HDDL" \
     -f null /dev/null;

elif grep --quiet 'Ubuntu 16' /etc/os-release; then
  wget -q -O - https://github.com/opencv/open_model_zoo/archive/2018_R5.tar.gz | tar xz && \
    cd open_model_zoo-2018_R5 && \
    cd model_downloader && \
    ./downloader.py --name vehicle-license-plate-detection-barrier-0106-fp16,vehicle-attributes-recognition-barrier-0039-fp16

  dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
  ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libx264 -y test.mp4
  ffmpeg -i test.mp4 -vf \
    "detect=model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_detection/barrier/0106/dldt/vehicle-license-plate-detection-barrier-0106-fp16.xml:device=HDDL, \
     classify=model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_attributes/vehicle/resnet10_update_1/dldt/vehicle-attributes-recognition-barrier-0039-fp16.xml:device=HDDL" \
     -f null /dev/null;
fi
