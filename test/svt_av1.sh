#!/bin/bash -e

dd if=/dev/urandom bs=115200 count=300 of=test.yuv # 10 seconds video
SvtAv1EncApp -i test.yuv -w 320 -h 240 -b out.ivf .
