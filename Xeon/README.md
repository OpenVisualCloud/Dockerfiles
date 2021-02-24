This folder contains docker files to build CPU software stack for Intel(R) Xeon(R) -SP or -D scalable processors.

### Setup host platform:

No special setup is needed except to install the docker.ce service and setup proxy if you are behind a firewall. See [../README.md](../README.md) for instructions.

### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|analytics-dev|[centos-7/analytics/dev](centos-7/analytics/dev)<br>[ubuntu-18.04/analytics/dev](ubuntu-18.04/analytics/dev)|[openvisualcloud/xeon-centos7-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-centos7-analytics-dev)<br>[openvisualcloud/xeon-ubuntu1804-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-dev)|
|analytics-ffmpeg|[centos-7/analytics/ffmpeg](centos-7/analytics/ffmpeg)<br>[ubuntu-18.04/analytics/ffmpeg](ubuntu-18.04/analytics/ffmpeg)|[openvisualcloud/xeon-centos7-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-centos7-analytics-ffmpeg)<br>[openvisualcloud/xeon-ubuntu1804-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-ffmpeg)|
|analytics-gst|[centos-7/analytics/gst](centos-7/analytics/gst)<br>[ubuntu-18.04/analytics/gst](ubuntu-18.04/analytics/gst)|[openvisualcloud/xeon-centos7-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-centos7-analytics-gst)<br>[openvisualcloud/xeon-ubuntu1804-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-gst)|
|graphics-dev|[centos-7/graphics/dev](centos-7/graphics/dev)<br>[ubuntu-18.04/graphics/dev](ubuntu-18.04/graphics/dev)|<br><br>|
|graphics-ospray|[centos-7/graphics/ospray](centos-7/graphics/ospray)<br>[ubuntu-18.04/graphics/ospray](ubuntu-18.04/graphics/ospray)|<br><br>|
|graphics-ospray-mpi|[centos-7/graphics/ospray-mpi](centos-7/graphics/ospray-mpi)<br>[ubuntu-18.04/graphics/ospray-mpi](ubuntu-18.04/graphics/ospray-mpi)|<br><br>|
|media-dev|[centos-7/media/dev](centos-7/media/dev)<br>[ubuntu-18.04/media/dev](ubuntu-18.04/media/dev)|[openvisualcloud/xeon-centos7-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-centos7-media-dev)<br>[openvisualcloud/xeon-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-dev)|
|media-ffmpeg|[centos-7/media/ffmpeg](centos-7/media/ffmpeg)<br>[ubuntu-18.04/media/ffmpeg](ubuntu-18.04/media/ffmpeg)|[openvisualcloud/xeon-centos7-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-centos7-media-ffmpeg)<br>[openvisualcloud/xeon-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-ffmpeg)|
|media-gst|[centos-7/media/gst](centos-7/media/gst)<br>[ubuntu-18.04/media/gst](ubuntu-18.04/media/gst)|[openvisualcloud/xeon-centos7-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-centos7-media-gst)<br>[openvisualcloud/xeon-ubuntu1804-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-gst)|
|media-nginx|[centos-7/media/nginx](centos-7/media/nginx)<br>[ubuntu-18.04/media/nginx](ubuntu-18.04/media/nginx)|[openvisualcloud/xeon-centos7-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-centos7-media-nginx)<br>[openvisualcloud/xeon-ubuntu1804-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-nginx)|
|media-svt|[centos-7/media/svt](centos-7/media/svt)<br>[ubuntu-18.04/media/svt](ubuntu-18.04/media/svt)|[openvisualcloud/xeon-centos7-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-centos7-media-svt)<br>[openvisualcloud/xeon-ubuntu1804-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-svt)|
|service-dev|[ubuntu-18.04/service/dev](ubuntu-18.04/service/dev)|[openvisualcloud/xeon-ubuntu1804-service-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-service-dev)|
|service-owt|[centos-7.6/service/owt](centos-7.6/service/owt)<br>[ubuntu-18.04/service/owt](ubuntu-18.04/service/owt)|[openvisualcloud/xeon-centos76-service-owt](https://hub.docker.com/r/openvisualcloud/xeon-centos76-service-owt)<br>[openvisualcloud/xeon-ubuntu1804-service-owt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-service-owt)|
|service-owt360|[centos-7.6/service/owt360](centos-7.6/service/owt360)||
