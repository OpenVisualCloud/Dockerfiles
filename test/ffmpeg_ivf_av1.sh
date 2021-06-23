#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=30 of=test.yuv # 30 frames
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvtav1 -f ivf -y test.ivf
