FFmpeg is a set of open source tools for audio and video processing, such as creating, converting/transcoding, and publishing media content.

### Audio/Video Codecs

The FFmpeg docker images are compiled with the following audio and video codecs:

| Codec | Version | Codec | Version |
|-------|:-------:|-------|:-------:|
|fdk-acc|0.1.6|x265|2.9|
|mp3lame|3.100|vpx|1.7.0|
|opus|1.2.1|aom|1.0.0|
|ogg|1.3.3|SVT-HEVC|1.3.0|
|vorbis|1.3.6|SVT-AV1|custom|
|x264|stable|SVT-VP9|custom|


### Patches

The FFmpeg builds included the following patches for feature enhancement, better performance or bug fixes:

| Patch | Description |
|-------|-------------|
|[11625](https://patchwork.ffmpeg.org/patch/11625/raw)|Enhance 1:N transcoding performance.|
|[11035](https://patchwork.ffmpeg.org/patch/11035/raw)|Fix libvpx to run on Intel(R) Xeon(R) processors.|
|[H.265 FLV](https://raw.githubusercontent.com/VCDP/CDN/master/The-RTMP-protocol-extensions-for-H.265-HEVC.patch)|Support H.265 in FLV for RTMP streaming.|

### GPU Acceleration

In GPU images, the FFmpeg docker images are accelerated through vaapi and/or qsv (Intel Media SDK).

### FFmpeg Examples:

Transcode raw yuv420 content to SVT-HEVC and mp4:

```bash
ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_hevc -y test.mp4
```

1:N Transcoding:

```bash
ffmpeg -i input.h264 -vf "scale=1280:720" -pix_fmt nv12 -f null /dev/null -vf "scale=720:480" -pix_fmt nv12 -f null /dev/null -abr_pipeline
```

Encoding/decoding with vaapi:

```bash
ffmpeg -y -vaapi_device /dev/dri/renderD128 -f rawvideo -video_size 320x240 -r 30 -i test.yuv -vf 'format=nv12, hwupload' -c:v h264_vaapi -y test.mp4
ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -i test.mp4 -f null /dev/null
```

Encoding/decoding with qsv (Intel Media SDK):

```bash
ffmpeg -y -init_hw_device qsv=hw -filter_hw_device hw -f rawvideo -pix_fmt yuv420p -s:v 320x240 -i test.yuv -vf hwupload=extra_hw_frames=64,format=qsv -c:v h264_qsv -b:v 5M test.mp4
ffmpeg -hwaccel qsv -c:v h264_qsv -i test.mp4 -f null /dev/null
```
