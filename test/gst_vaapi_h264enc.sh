#!/bin/bash -e

case "$1" in
    xeon_*)
        echo "Skipped for a CPU only platform"
        ;;
    *)
        dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
        gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=nv12 width=320 height=240 framerate=30 ! vaapih264enc ! mpegtsmux ! filesink location=test.ts
        ;;
esac
