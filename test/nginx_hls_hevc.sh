#!/bin/bash -ve

nginx &

case "$1" in
    *ubuntu*)
        apt-get update && apt-get install -y -q --no-install-recommends curl;;
    *centos*)
        yum install -y -q curl;;
esac 

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
#ffmpeg -re -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_hevc -f flv rtmp://localhost/hls/test
#curl -sSf http://127.0.0.1/hls/test/index.m3u8
