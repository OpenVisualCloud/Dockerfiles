#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=30 of=test.yuv # 30 frames
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_vp9 -y test.mp4
ffprobe -v error -show_streams test.mp4
