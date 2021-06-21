Scalable Video Technology (SVT) is a software-based video coding technology that is highly optimized for Intel<sup>®</sup> Xeon<sup>®</sup> Scalable processors and Intel<sup>®</sup> Xeon<sup>®</sup> D processors. SVT provides flexible high-performance software encoder core libraries for media and visual cloud developers.

### SVT modules

SVT Images get built with following SVT transcoders

|Module|Version|Comment
|------|------|------|
|SVT-HEVC|v1.5.1|HEVC-compliant encoder library core that achieves excellent density-quality tradeoffs|
|SVT-AV1|v0.8.7|AV1 Compliant encoder library for VOD and Live encoding / transcoding video applications|
|SVT-VP9|v0.2.2|VP9 Compliant encoder library for VOD and Live encoding / transcoding video applications|

### Evaluate SVT 

The easiest way to evalute SVT is through the latest release on [Docker Hub](https://hub.docker.com/u/openvisualcloud), log onto a Linux PC with docker engine installed, execute "docker run <_image_> <_command_>" to try various SVT related functions. Refer to below examples: 

- SVT HEVC encoder:
```bash
sudo -E docker run openvisualcloud/xeon-ubuntu1804-media-svt /bin/bash -c "dd if=/dev/urandom bs=115200 count=300 of=test.yuv && SvtHevcEncApp -i test.yuv -w 320 -h 240 -b out.ivf ."
```
- SVT AV1 encoder:
```bash
sudo -E docker run openvisualcloud/xeon-centos76-media-svt /bin/bash -c "dd if=/dev/urandom bs=115200 count=300 of=test.yuv && SvtAV1EncApp -i test.yuv -w 320 -h 240 -b out.ivf ."
```
- SVT VP9 encoder:
```bash
sudo -E docker run openvisualcloud/xeon-ubuntu1804-media-svt /bin/bash -c "dd if=/dev/urandom bs=115200 count=300 of=test.yuv && SvtVp9EncApp -i test.yuv -w 320 -h 240 -b out.ivf ."
```
- SVT HEVC with FFmpeg:
```bash
sudo -E docker run openvisualcloud/xeon-ubuntu1804-media-ffmpeg /bin/bash -c "dd if=/dev/urandom bs=115200 count=300 of=test.yuv && ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_hevc -y test.mp4"
```
- SVT AV1 with FFmpeg:
```bash
sudo -E docker run openvisualcloud/xeon-centos76-media-ffmpeg /bin/bash -c "dd if=/dev/urandom bs=115200 count=300 of=test.yuv && ffmpeg -f rawvideo -vcodec rawvideo -s 320x240 -r 30 -pix_fmt yuv420p -i test.yuv -c:v libsvt_av1 -y test.mp4"
```

