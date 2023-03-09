#!/bin/bash -ve

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
ffmpeg -re -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_hevc -f dash ./test_dash.mpd
