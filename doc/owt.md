The media server for Open WebRTC Toolkit (OWT) provides an efficient video conference and streaming service that is based on WebRTC. It scales a single WebRTC stream out to many endpoints and supports real-time video and audio transcoding. 

### Supported Media Codecs

The OWT service Docker images are compiled with following audio and video codec:

Name|Type
-----|-----
opus | audio
pcma | audio
pcmu | audio
aac | audio
ac3 | audio
nellymoser | audio
h264 | video
h265 | video
vp8 | video
vp9 | video

### Default bitrate for typical resolutions (30fps)**
|Resolution|Default bitrate(kbps)|
|------|------|
|352x288 (cif)|442|
|176x144 (qcif)|132|
|320x240 (sif)|400|
|640x480 (vga)|800|
|800x600 (svga)|1137|
|1024x768 (xga)|1736|
|480x320 (hvga)|533|
|1280x720 (hd720p)|2000|
|1920x1080 (hd1080p)|4000|
|3840x2160 (uhd_4k)|16000|

### OWT service modules:

The OWT serive images are compiled with the following modules:

|Component Name|Responsibility
--------|--------
management-api|The entrance of OWT service, keeping the configurations of all rooms, generating and verifying the tokens. Application can implement load balancing strategy across multiple management-api instances
cluster-manager|The manager of all active workers in the cluster, checking their lives, scheduling workers with the specified purposes according to the configured policies. If one has been elected as master, it will provide service; others will be standby
portal|The signaling server, handling service requests from Socket.IO clients
conference-agent|This agent handles room controller logics
webrtc-agent|This agent spawning webrtc accessing nodes which establish peer-connections with webrtc clients, receive media streams from and send media streams to webrtc clients
streaming-agent|This agent spawning streaming accessing nodes which pull external streams from sources and push streams to rtmp/rtsp destinations
recording-agent|This agent spawning recording nodes which record the specified audio/video streams to permanent storage facilities
audio-agent|This agent spawning audio processing nodes which perform audio transcoding and mixing
video-agent|This agent spawning video processing nodes which perform video transcoding and mixing
sip-agent|This agent spawning sip processing nodes which handle sip connections
sip-portal|The portal for initializing sip conectivity for rooms

### OWT service launch:

Before running OWT service, mongodb and rabbitmq services need to be launched. We provide a launch script compiled in Docker image to launch OWT service:

```bash
/home/launch.sh
```
