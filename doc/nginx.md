NGINX is a popular web server that can be used for serving web content, load balancing, HTTP caching, or a reverse proxy.

### Patches

The NGINX builds included the following patches for feature enhancement, better performance or bug fixes:

| Patch | Description |
|-------|-------------|
|[H.265 DASH](https://raw.githubusercontent.com/VCDP/CDN/master/0002-add-HEVC-support-for-dash.patch)|Support H.265 in NGINX DASH.|
|[H.265 HLS](https://raw.githubusercontent.com/VCDP/CDN/master/0001-add-hevc-support-for-rtmp-and-hls.patch)|Support H.265 in NGINX RTMP/HLS.|

### NGINX Modules

The NGINX images are compiled with the following modules:

|Module|Module|Module|Module|
|------|------|------|------|
|select|pull|HTTP SSL|HTTP v2|
|HTTP real IP|HTTP addition|HTTP XSLT|HTTP sub|
|HTTP DAV|HTTP FLV|HTTP MP4|HTTP GUNZIP|
|HTTP GZIP static|HTTP auth request|HTTP random index|HTTP secure link|
|HTTP degradation|HTTP slice|HTTP stub status|stream ssl|
|stream real IP|stream SSL preread|RTMP|Upload|

### NGINX Configuration

The default NGINX configuration exposes the following entry points:

|Port| Entry Point | Description |
|----|-------------|-------------|
|80|/|Serve an empty page.|
|80|/dash|Serve MPEG DASH content.|
|80|/hls|Serve HLS content.|
|80|/stat|Serve the RTMP module status page.|
|80|/upload|Upload files.|
|1935|/stream|Publish/retrieve RTMP live streams.|
|1935|/dash|Publish RTMP streams to generate DASH content.|
|1935|/hls|Publish RTMP streams to generate HLS content.|
