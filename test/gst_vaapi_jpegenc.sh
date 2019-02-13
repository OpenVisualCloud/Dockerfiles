#!/bin/bash -e

case "$1" in
    xeon_*)
        echo "Skipped for a CPU only platform"
        ;;
    *)
        dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
        gst-launch-1.0 -v videotestsrc num-buffers=1 ! vaapijpegenc ! filesink location=test.jpg
        ;;
esac
