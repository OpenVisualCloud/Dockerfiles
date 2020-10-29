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

if grep --quiet 'Ubuntu 16' /etc/os-release; then
  wget -q -O - https://github.com/opencv/open_model_zoo/archive/2018_R5.tar.gz | tar xz && \
    cd open_model_zoo-2018_R5 && \
    cd model_downloader && \
    ./downloader.py --name vehicle-license-plate-detection-barrier-0106,vehicle-attributes-recognition-barrier-0039,license-plate-recognition-barrier-0001

  dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
  gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
  gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
    gvadetect model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_detection/barrier/0106/dldt/vehicle-license-plate-detection-barrier-0106.xml device=HDDL ! queue ! \
    gvaclassify model=/home/open_model_zoo-2018_R5/model_downloader/Security/object_attributes/vehicle/resnet10_update_1/dldt/vehicle-attributes-recognition-barrier-0039.xml object-class=vehicle device=HDDL ! queue ! \
    gvaclassify model=/home/open_model_zoo-2018_R5/model_downloader/Security/optical_character_recognition/license_plate/dldt/license-plate-recognition-barrier-0001.xml object-class=license-plate device=HDDL ! queue ! \
    gvawatermark ! videoconvert ! fakesink;

elif grep --quiet 'Ubuntu 18' /etc/os-release; then
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-license-plate-detection-barrier-0106/FP32/vehicle-license-plate-detection-barrier-0106.bin
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-license-plate-detection-barrier-0106/FP32/vehicle-license-plate-detection-barrier-0106.xml
  wget https://raw.githubusercontent.com/openvinotoolkit/dlstreamer_gst/master/samples/model_proc/vehicle-license-plate-detection-barrier-0106.json

  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-attributes-recognition-barrier-0039/FP32/vehicle-attributes-recognition-barrier-0039.bin
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/vehicle-attributes-recognition-barrier-0039/FP32/vehicle-attributes-recognition-barrier-0039.xml
  wget https://raw.githubusercontent.com/openvinotoolkit/dlstreamer_gst/master/samples/model_proc/vehicle-attributes-recognition-barrier-0039.json


  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/license-plate-recognition-barrier-0001/FP32/license-plate-recognition-barrier-0001.bin
  wget https://download.01.org/opencv/2021/openvinotoolkit/2021.1/open_model_zoo/models_bin/2/license-plate-recognition-barrier-0001/FP32/license-plate-recognition-barrier-0001.xml
  wget https://raw.githubusercontent.com/openvinotoolkit/dlstreamer_gst/master/samples/model_proc/license-plate-recognition-barrier-0001.json

  dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
  gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
  gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
    gvadetect model=vehicle-license-plate-detection-barrier-0106.xml model-proc=vehicle-license-plate-detection-barrier-0106.json device=HDDL ! queue ! \
    gvaclassify model=vehicle-attributes-recognition-barrier-0039.xml object-class=vehicle model-proc=vehicle-attributes-recognition-barrier-0039.json device=HDDL ! queue ! \
    gvaclassify model=license-plate-recognition-barrier-0001.xml object-class=license-plate model-proc=license-plate-recognition-barrier-0001.json device=HDDL ! queue ! \
    gvawatermark ! videoconvert ! fakesink;
fi
