FFmpeg is a set of open source tools for audio and video processing, such as creating, converting/transcoding, and publishing media content.

### Audio/Video Codecs:

The FFmpeg docker images are compiled with the following audio and video codecs:

| Codec | Version | Codec | Version |
|-------|:-------:|-------|:-------:|
|fdk-acc|0.1.6|x265|2.9|
|mp3lame|3.100|vpx|1.7.0|
|opus|1.2.1|dav1d|0.5.2|
|ogg|1.3.3|SVT-HEVC|v1.5.0|
|vorbis|1.3.6|SVT-AV1|v0.8.5|
|x264|stable|SVT-VP9*|v0.2.1|

\* SVT-VP9 encoder app only. SVT-VP9 not yet available as a FFmpeg plugin. 

### Patches:

The FFmpeg builds included the following patches for feature enhancement, better performance or bug fixes:

| Patch | Description |
|-------|-------------|
|[11625](https://patchwork.ffmpeg.org/patch/11625/raw)|Enhance 1:N transcoding performance.|
|[H.265 FLV](https://github.com/VCDP/CDN/archive/v0.1.tar.gz)|Support H.265 in FLV for RTMP streaming.|
|[ANALYTICS](https://github.com/VCDP/FFmpeg-patch/tree/ffmpeg4.2_va/patches )|Enables FFmpeg analytics pipeline with the elementary inference features.|
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

- Face detection and emotion identification, save metadata to json format:

```bash
ffmpeg -i ~/Videos/xxx.mp4 -vf detect=model=./face-detection-adas-0001/FP32/face-detection-adas-0001.xml:device=CPU, \
classify=model=./emotions_recognition/emotions-recognition-retail-0003.xml:model_proc=emotions-recognition-retail-0003.json:device=CPU, \
metaconvert=converter=json:method=all \
-an -f metapublish -output_format batch -y emotion-meta.json
```

- Object Detection:  

```bash
ffmpeg -i ~/Videos/xxx.mp4 -vf detect=model=./mobilenet-ssd.xml:model_proc=mobilenet-ssd.json:device=CPU -an -f null /dev/null
```

- Face detection and reidentification:  

```bash
ffmpeg -i ~/Videos/xxx.mp4 -vf "detect=model=./face-detection-retail-0004.xml:device=CPU, \
classify=model=./face-reidentification-retail-0095.xml:model_proc=./face-reidentification-retail-0095.json:device=CPU,identify=gallery=./gallery, \
metaconvert=converter=json:method=all" \
-f metapublish -output_format batch -y /tmp/face-identify.json
```

- Car attribute recognition:  

```bash
ffmpeg -i ~/Videos/xxx.mp4 -vf "detect=model=vehicle-detection-adas-0002.xml:model_proc=vehicle-detection-adas-0002.json:device=CPU, \
classify=model=vehicle-attributes-recognition-barrier-0039.xml:model_proc=vehicle-attributes-recognition-barrier-0039.json:device=CPU" -an -f null /dev/null
```

- Car-Bike-Person detection:

```bash
ffmpeg -i ~/Videos/xxx.mp4 -vf "detect=model=person-vehicle-bike-detection-crossroad-0078.xml:model_proc=person-vehicle-bike-detection-crossroad-0078.json:device=CPU" -an -f null /dev/null
```

- GPU decode with `VAAPI` + detection:

```bash
ffmpeg -flags unaligned -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device /dev/dri/renderD128 \
-i $STREAM -vf "detect=model=$DETECTION_MODEL:device=$DEVICE" -an -f null - \
```

- Face detection, classification with display:

```bash
ffplay $SOURCE -sync video -vf \
  "detect=model=$DETECT_MODEL_PATH:device=$DEVICE, \
   classify=model=$CLASS_MODEL_PATH:model_proc=$MODEL_PROC:device=$DEVICE,   \
   classify=model=$CLASS_MODEL_PATH1:model_proc=$MODEL1_PROC:device=$DEVICE, \
   ocv_overlay"
```

### See Also

- [FFmpeg Video Analytics Plugin](https://github.com/VCDP/FFmpeg-patch)
