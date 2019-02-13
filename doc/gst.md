
GStreamer is a framework of audio and video plugins that can be connected to process audio and video content, such as creating, converting, transcoding, and publishing media content. 

### Audio/Video Codecs

The GStreamer docker images are compiled with the following plugin set:
- gst-plugin-base
- gst-plugin-good
- gst-plugin-bad
- gst-plugin-ugly
- gst-plugin-vaapi
- gst-plugin-libav

### GPU Acceleration

In GPU images, the GStreamer docker images are accelerated through vaapi. Note that gst-plugin-vaapi requires special setup for X11 authentication. Please see each platform README for setup details.

### GStreamer Examples:

Transcode raw yuv420 content to mp4:

```bash
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
```

Encoding with vaapi:

```bash
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! vaapih264enc ! mpegtsmux ! filesink location=test.ts
```
