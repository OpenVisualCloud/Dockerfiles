#!/bin/bash -ve

dd if=/dev/urandom bs=3110400 count=300 of=test-1920x1080.yuv # 10 seconds video
ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw -f rawvideo -pix_fmt yuv420p -s:v 1920x1080 -i test-1920x1080.yuv -vf hwupload=extra_hw_frames=64,format=qsv -c:v hevc_qsv -b:v 5M test-1920x1080.mp4
ffprobe -v error -show_streams test-1920x1080.mp4
ffmpeg -hwaccel qsv -c:v hevc_qsv -i test-1920x1080.mp4 -f null /dev/null
