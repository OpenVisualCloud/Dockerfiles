#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=100 of=test.yuv # 3 second video
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libx264 -y test.mp4
ffmpeg -i test.mp4 -vf "scale=1280:720" -pix_fmt nv12 -f null /dev/null -vf "scale=720:480" -pix_fmt nv12 -f null /dev/null
