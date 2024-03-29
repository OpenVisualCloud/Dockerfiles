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
### OWT service configuration for public cloud:

The OWT service provides the following settings in configuration files to configure the network interfaces for public cloud (like AWS) access:

|Configuration Item|Location|Usage|
|------|------|------|
|webrtc.network_interfaces | webrtc_agent/agent.toml | The network interfaces of webrtc-agent that clients in public network can connect to|
|webrtc.minport | webrtc_agent/agent.toml | The webrtc port range lowerbound for clients to connect through UDP|
|webrtc.maxport | webrtc_agent/agent.toml | The webrtc port range upperbound for clients to connect through UDP|
|management-api.port | management_api/management_api.toml | The port of management-api should be accessible in public network through TCP|
|portal.hostname, portal.ip_address | portal/portal.toml | The hostname and IP address of portal for public access; hostname first if it is not empty.|
|portal.port | portal/portal.toml | The port of portal for public access through TCP|

Note: You also need to configure your cloud security rule to allow public access to ports listed in above table.

### OWT Environment Requirement

Different module tries to connect to RabbitMQ server running on the same system. Hence, no_proxy variable needs to be specified:

```bash
export no_proxy=localhost
```
### OWT server and client document:

For more documents on OWT server and SDK, please refer to following links:

[OWT server](https://github.com/open-webrtc-toolkit/owt-server/blob/5.1.0/doc/servermd/Server.md): OWT server installation and deployment guide.

[OWT RESTAPI](https://github.com/open-webrtc-toolkit/owt-server/blob/5.1.0/doc/servermd/RESTAPI.md): OWT RESTful API guide.

[JS SDK API](https://github.com/open-webrtc-toolkit/owt-client-javascript/tree/4.3.x/docs): OWT javascript SDK API guide.

You can also go to [Intel WebRTC](https://software.intel.com/content/www/us/en/develop/tools/webrtc-sdk.html#developer-guides-references) to download all the released documents.
