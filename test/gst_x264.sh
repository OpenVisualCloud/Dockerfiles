#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! filesink location=test.xx
