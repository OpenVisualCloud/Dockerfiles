#!/bin/bash -e

case "$1" in
    xeon_*)
        echo "Skipped for a CPU only platform"
        ;;
    *)
        dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
        ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw -f rawvideo -pix_fmt yuv420p -s:v 320x240 -i test.yuv -vf hwupload=extra_hw_frames=64,format=qsv -c:v h264_qsv -b:v 5M test.mp4
        ffmpeg -hwaccel qsv -c:v h264_qsv -i test.mp4 -f null /dev/null
        ;;
esac
