
GStreamer is a framework of audio and video plugins that can be connected to process audio and video content, such as creating, converting, transcoding, and publishing media content.

### Plugins:

The GStreamer docker images are compiled with the following plugin set:

| Plugin | Version| Plugin | Version|
|:---|:---:|:---|:---:|
|`gst-plugin-bas`|1.16.0|`gst-plugin-good`|1.16.0|
|`gst-plugin-bad`|1.16.0|`gst-plugin-ugly`|1.16.0|
|`gst-plugin-vaapi`|1.16.0|`gst-plugin-libav`|1.16.0|
|`gst-video-analytics`|0.7.0|`SVT-HEVC encoder`|v1.4.3|
|`gst-python`|1.16.0|`SVT-VP9 encoder`|v0.2.0|
|||`SVT-AV1 encoder`|v0.8.4|

---

The plugins `shm` and `mxf` from `gst-plugin-bad` is disabled as they do not meet security coding guidelines. Please file an issue if you need these plugin features in your project.

---

### GPU Acceleration:

In GPU images, the GStreamer docker images are accelerated through `VAAPI`. Note that `gst-plugin-vaapi` requires special setup for X11 authentication. Please see each platform README for setup details.

### Examples:

- Transcode raw yuv420 content to mp4:  

```bash
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! x264enc ! mpegtsmux ! filesink location=test.ts
```

- Encoding with `VAAPI`:  

```bash
gst-launch-1.0 -v filesrc location=test.yuv ! videoparse format=i420 width=320 height=240 framerate=30 ! vaapih264enc ! mpegtsmux ! filesink location=test.ts
```

- Encoding with SVT encoders:  

```bash
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svthevcenc! mpegtsmux ! filesink location=hevc.ts
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svtav1enc ! webmmux ! filesink location=av1.mkv
gst-launch-1.0 -v videotestsrc ! video/x-raw ! svtvp9enc ! webmmux ! filesink location=vp9.mkv
```

- Use the Intel<sup>&reg;</sup> OpenVINO<sup>&trade;</sup> inference engine to detect items in a scene: 

```bash
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
  gvadetect model=<path to xml of model optimized through DLDT's model optimizer> ! queue ! \
  gvawatermark ! videoconvert ! fakesink
```

- Use the Intel OpenVINO inference engine to classify items in a scene:  

```bash
gst-launch-1.0 -v filesrc location=test.ts ! decodebin ! video/x-raw ! videoconvert ! \
  gvadetect model=<full path to xml of model optimized through DLDT's model optimizer> ! queue ! \
  gvaclassify model=<full path to xml of model optimized through DLDT's model optimizer> object-class=vehicle ! queue ! \
  gvawatermark ! videoconvert ! fakesink
```

### See Also:

- [GStreamer Video Analytics Plugin](https://github.com/opencv/gst-video-analytics)   

