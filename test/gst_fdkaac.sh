#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=300 of=test.pcm
gst-launch-1.0 filesrc location=test.pcm ! audio/x-raw,format=S16LE,channels=1,rate=8000 ! fdkaacenc ! filesink location=test.wav
