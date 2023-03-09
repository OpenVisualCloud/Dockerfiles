#!/bin/bash -ve
case "$1" in
    xeon_*)
        echo "Skipped for a CPU only platform"
        ;;
    *)
        dd if=/dev/urandom bs=115200 count=300 of=test-320x240.yuv # 10 seconds video
        ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw -f rawvideo -pix_fmt yuv420p -s:v 320x240 -i test-320x240.yuv -vf hwupload=extra_hw_frames=64,format=qsv -c:v h264_qsv -b:v 5M test-320x240.mp4
        ffprobe -v error -show_streams test-320x240.mp4
        ffmpeg -hwaccel qsv -c:v h264_qsv -i test-320x240.mp4 -f null /dev/null
esac
