#!/bin/bash -ve

sed -i 's/worker_processes auto/worker_processes 1/' /etc/nginx/nginx.conf
nginx &

case "$1" in
    *ubuntu*)
        apt-get update && apt-get install -y -q --no-install-recommends curl;;
    *centos*)
        yum install -y -q curl;;
esac

curl -sSf http://127.0.0.1/stat
dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
ffmpeg -i rtmp://127.0.0.1/stream/test -vcodec copy -acodec copy -f flv test.flv < /dev/null &
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libx264 -f flv rtmp://127.0.0.1/stream/test
if test -f test.flv; then exit 0; else exit -1; fi

sed -i 's/worker_processes 1/worker_processes auto/' /etc/nginx/nginx.conf
