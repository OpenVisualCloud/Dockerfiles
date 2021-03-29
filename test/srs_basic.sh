#!/bin/bash -e

test $(ldd /usr/local/srs/objs/srs | grep "not found" | wc -l) -eq 0
test $(ldd /usr/local/bin/ffmpeg | grep "not found" | wc -l) -eq 0

