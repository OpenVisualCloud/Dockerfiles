
This folder contains docker files to build CPU software stack for Intel(R) Xeon(R) -SP or -D scalable processors.

### Setup host platform:

No special setup is needed except to install the docker.ce service and setup proxy if you are behind a firewall. See [../README.md](../README.md) for instructions.

### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|analytics-dev|[ubuntu-22.04/analytics/dev](ubuntu-22.04/analytics/dev)<br>[ubuntu-20.04/analytics/dev](ubuntu-20.04/analytics/dev)|[openvisualcloud/xeon-ubuntu2204-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-analytics-dev)<br>[openvisualcloud/xeon-ubuntu2004-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-analytics-dev)|
|analytics-ffmpeg|[ubuntu-22.04/analytics/ffmpeg](ubuntu-22.04/analytics/ffmpeg)<br>[ubuntu-20.04/analytics/ffmpeg](ubuntu-20.04/analytics/ffmpeg)|[openvisualcloud/xeon-ubuntu2204-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-analytics-ffmpeg)<br>[openvisualcloud/xeon-ubuntu2004-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-analytics-ffmpeg)|
|analytics-gst|[ubuntu-22.04/analytics/gst](ubuntu-22.04/analytics/gst)<br>[ubuntu-20.04/analytics/gst](ubuntu-20.04/analytics/gst)|[openvisualcloud/xeon-ubuntu2204-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-analytics-gst)<br>[openvisualcloud/xeon-ubuntu2004-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-analytics-gst)|
|media-dev|[ubuntu-22.04/media/dev](ubuntu-22.04/media/dev)<br>[ubuntu-20.04/media/dev](ubuntu-20.04/media/dev)|[openvisualcloud/xeon-ubuntu2204-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-dev)<br>[openvisualcloud/xeon-ubuntu2004-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-dev)|
|media-ffmpeg|[ubuntu-22.04/media/ffmpeg](ubuntu-22.04/media/ffmpeg)<br>[ubuntu-20.04/media/ffmpeg](ubuntu-20.04/media/ffmpeg)|[openvisualcloud/xeon-ubuntu2204-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-ffmpeg)<br>[openvisualcloud/xeon-ubuntu2004-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-ffmpeg)|
|media-gst|[ubuntu-22.04/media/gst](ubuntu-22.04/media/gst)<br>[ubuntu-20.04/media/gst](ubuntu-20.04/media/gst)|[openvisualcloud/xeon-ubuntu2204-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-gst)<br>[openvisualcloud/xeon-ubuntu2004-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-gst)|
|media-nginx|[ubuntu-22.04/media/nginx](ubuntu-22.04/media/nginx)<br>[ubuntu-20.04/media/nginx](ubuntu-20.04/media/nginx)|[openvisualcloud/xeon-ubuntu2204-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-nginx)<br>[openvisualcloud/xeon-ubuntu2004-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-nginx)|
|media-srs|[ubuntu-22.04/media/srs](ubuntu-22.04/media/srs)<br>[ubuntu-20.04/media/srs](ubuntu-20.04/media/srs)|[openvisualcloud/xeon-ubuntu2204-media-srs](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-srs)<br>[openvisualcloud/xeon-ubuntu2004-media-srs](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-srs)|
|media-svt|[ubuntu-22.04/media/svt](ubuntu-22.04/media/svt)<br>[ubuntu-20.04/media/svt](ubuntu-20.04/media/svt)|[openvisualcloud/xeon-ubuntu2204-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2204-media-svt)<br>[openvisualcloud/xeon-ubuntu2004-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-media-svt)|
|service-owt-dev|[ubuntu-20.04/service/owt-dev](ubuntu-20.04/service/owt-dev)|[openvisualcloud/xeon-ubuntu2004-service-owt-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-service-owt-dev)|
|service-owt|[ubuntu-20.04/service/owt](ubuntu-20.04/service/owt)|[openvisualcloud/xeon-ubuntu2004-service-owt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu2004-service-owt)|
