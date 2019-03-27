#!/bin/bash -e

if grep --quiet 'NAME="CentOS Linux"' /etc/os-release; then
  yum install -y centos-release-scl wget
  yum install -y rh-python36
  source /opt/rh/rh-python36/enable
else
  apt-get update
  apt-get install -y wget make python3 python3-pip
fi

pip3 install pyyaml requests

wget -q -O - https://github.com/opencv/open_model_zoo/archive/2018_R5.tar.gz | tar xz && \
  cd open_model_zoo-2018_R5 && \
  cd model_downloader && \
  ./downloader.py --name vehicle-license-plate-detection-barrier-0106,vehicle-attributes-recognition-barrier-0039,license-plate-recognition-barrier-0001

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
  gvadetect model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_detection/barrier/0106/dldt/vehicle-license-plate-detection-barrier-0106.xml ! queue ! \
  gvaclassify model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_attributes/vehicle/resnet10_update_1/dldt/vehicle-attributes-recognition-barrier-0039.xml object-class=vehicle ! queue ! \
  gvaclassify model=/home/open_model_zoo-2018_R5/model_downloader/Security/optical_character_recognition/license_plate/dldt/license-plate-recognition-barrier-0001.xml object-class=license-plate ! queue ! \
  gvawatermark ! videoconvert ! fakesink
