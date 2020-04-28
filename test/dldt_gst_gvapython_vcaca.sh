#!/bin/bash -e
rm -rf /home/signal
mkdir -p /home/signal
cat > /home/testgva.py << EOF
from gstgva import VideoFrame, util
from pathlib import Path
class testgva:
    def __init__(self):
        Path('/home/signal/__init__').touch()

    def process_frame(self, frame):
        Path('/home/signal/process_frame').touch()
        return True
EOF

dd if=/dev/urandom bs=115200 count=30 of=/home/test.yuv # 1 seconds video
PATH="/home:$PATH" gst-launch-1.0 -v filesrc location=/home/test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! videoconvert ! video/x-raw,format=BGRx ! gvapython module="testgva" class="testgva" ! fakesink
test -f /home/signal/__init__
test -f /home/signal/process_frame

