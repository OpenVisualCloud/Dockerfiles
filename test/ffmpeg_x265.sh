#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libx265 -y test.mp4
ffmpeg -i test.mp4 -vcodec libx265 -f null /dev/null
