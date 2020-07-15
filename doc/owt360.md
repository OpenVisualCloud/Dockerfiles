The Open WebRTC Toolkit (OWT) media server for ultra-high resolution immersive video provides a low latency streaming service. It supports tile based 4K and 8K transcoding for immersive video powered by SVT-HEVC, and also field of view (FoV) adaptive streaming according to client viewport feedback which can save much of the network bandwidth.

### Supported Video Projections

|Type
|-----
|Equirectangular (ERP)

### Supported Resolutions

|Type|Resolution|Tiles
|-----|-----|-----
|4K|3840x2048|10x8
|8K|7680x3840|12x6

### Supported Input Video Codecs

Type|
-----|
H264|
HEVC|
VP8|
VP9|

### OWT immersive service launch:

Before running OWT immersive service, mongodb and rabbitmq services need to be launched. We provide a launch script compiled in Docker image to launch OWT service:

```bash
/home/launch.sh
```

### See Also:
- [owt.md](owt.md)
- [Open WebRTC Toolkit](https://github.com/open-webrtc-toolkit)

