
GStreamer is a framework of audio and video plugins that can be connected to process audio and video content, such as creating, converting, transcoding, and publishing media content. 

### Audio/Video Codecs

The GStreamer docker images are compiled with the following plugin set:
- gst-plugin-base
- gst-plugin-good
- gst-plugin-bad
- gst-plugin-ugly
- gst-plugin-vaapi
- gst-plugin-libav
- gst-video-analytics
- SVT-HEVC/AV1/VP9 encoders

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

Encoding with SVT encoders:

```bash
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svthevcenc! mpegtsmux ! filesink location=hevc.ts
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svtav1enc ! webmmux ! filesink location=av1.mkv
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svtvp9enc ! webmmux ! filesink location=vp9.mkv
```

Use DLDT's Inference Engine to detect items in a scene using video analytics

```bash
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
  gvadetect model=<path to xml of model optimized through DLDT's model optimizer> ! queue ! \
  gvawatermark ! videoconvert ! fakesink
```

Use DLDT's Inference Engine to classify items in a scene using video analytics

```bash
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
  gvadetect model=<full path to xml of model optimized through DLDT's model optimizer> ! queue ! \
  gvaclassify model=<full path to xml of model optimized through DLDT's model optimizer> object-class=vehicle ! queue ! \
  gvawatermark ! videoconvert ! fakesink
```
