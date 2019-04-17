#!/bin/bash -e

mkdir build
cd build
cmake ..
cd Xeon/centos-7.4/ffmpeg+gst+dev
make >> log_centos_74_ffmpeg_gst_dev.log
