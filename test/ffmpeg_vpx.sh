#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=30 of=test.yuv # 1 second video
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libvpx-vp9 -y test.webm
ffmpeg -i test.webm -vcodec libvpx-vp9 -f null /dev/null
