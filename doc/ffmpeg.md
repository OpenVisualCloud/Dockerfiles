FFmpeg is a set of open source tools for audio and video processing, such as creating, converting/transcoding, and publishing media content.

### Audio/Video Codecs:

The FFmpeg docker images are compiled with the following audio and video codecs:

| Codec | Version | Codec | Version |
|-------|:-------:|-------|:-------:|
|fdk-acc|2.0.2|x265|3.4|
|vpx|1.10.0|opus|1.3.1|
|dav1d|0.9.0|ogg|1.3.5|
|SVT-HEVC|v1.5.1|vorbis|1.3.7|
|SVT-AV1|v0.8.7|x264|stable|
|SVT-VP9*|v0.2.2|

\* SVT-VP9 encoder app only. SVT-VP9 not yet available as a FFmpeg plugin. 

### Patches:

The FFmpeg builds included the following patches for feature enhancement, better performance or bug fixes:

| Patch | Description |
|-------|-------------|
|[11625](https://patchwork.ffmpeg.org/patch/11625/raw)|Enhance 1:N transcoding performance.|
|[SVT-HEVC](https://github.com/OpenVisualCloud/SVT-HEVC/tree/master/ffmpeg_plugin)|Enable FFmpeg SVT-HEVC plugin|
|[SVT-AV1](https://github.com/OpenVisualCloud/SVT-AV1/tree/master/ffmpeg_plugin)|Enable FFmpeg SVT-AV1 plugin|

### GPU Acceleration:

In GPU images, the FFmpeg docker images are accelerated through `VAAPI` and/or `qsv` (Intel<sup>&reg;</sup> Media SDK). Note that `VAAPI` or `qsv` requires special setup for X11 authentication. Please see each platform README for setup details.

### Examples:

- Transcode raw yuv420 content to SVT-HEVC and mp4:  

```bash
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_hevc -y test.mp4
```

- 1:N Transcoding:  

```bash
ffmpeg -i input.h264 -vf "scale=1280:720" -pix_fmt nv12 -f null /dev/null -vf "scale=720:480" -pix_fmt nv12 -f null /dev/null -abr_pipeline
```

- Encoding/decoding with `VAAPI`:  

```bash
ffmpeg -y -vaapi_device /dev/dri/renderD128 -f rawvideo -video_size 320x240 -r 30 -i test.yuv -vf 'format=nv12, hwupload' -c:v h264_vaapi -y test.mp4
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -i test.mp4 -f null /dev/null
```

- Encoding/decoding with `qsv` (Intel Media SDK):  

```bash
ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw -f rawvideo -pix_fmt yuv420p -s:v 320x240 -i test.yuv -vf hwupload=extra_hw_frames=64,format=qsv -c:v h264_qsv -b:v 5M test.mp4
ffmpeg -hwaccel qsv -c:v h264_qsv -i test.mp4 -f null /dev/null
```
