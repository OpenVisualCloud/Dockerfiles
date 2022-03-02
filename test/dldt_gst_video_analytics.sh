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

wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/vehicle-license-plate-detection-barrier-0106/FP32/vehicle-license-plate-detection-barrier-0106.bin
wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/vehicle-license-plate-detection-barrier-0106/FP32/vehicle-license-plate-detection-barrier-0106.xml

wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/vehicle-attributes-recognition-barrier-0039/FP32/vehicle-attributes-recognition-barrier-0039.bin
wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/vehicle-attributes-recognition-barrier-0039/FP32/vehicle-attributes-recognition-barrier-0039.xml

wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/license-plate-recognition-barrier-0001/FP32/license-plate-recognition-barrier-0001.bin
wget https://storage.openvinotoolkit.org/repositories/open_model_zoo/2021.4/models_bin/1/license-plate-recognition-barrier-0001/FP32/license-plate-recognition-barrier-0001.xml

wget -O - https://github.com/dlstreamer/dlstreamer/archive/refs/tags/v1.5.3.tar.gz | tar xz

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
	gvadetect model=vehicle-license-plate-detection-barrier-0106.xml model-proc=dlstreamer-1.5.3/samples/model_proc/intel/object_detection/vehicle-license-plate-detection-barrier-0106.json ! queue ! \
	gvaclassify model=vehicle-attributes-recognition-barrier-0039.xml object-class=vehicle model-proc=dlstreamer-1.5.3/samples/model_proc/intel/object_attribute_estimation/vehicle-attributes-recognition-barrier-0039.json ! queue ! \
	gvaclassify model=license-plate-recognition-barrier-0001.xml object-class=license-plate model-proc=dlstreamer-1.5.3/samples/model_proc/intel/optical_character_recognition/license-plate-recognition-barrier-0001.json ! queue ! \
	gvawatermark ! videoconvert ! fakesink;
