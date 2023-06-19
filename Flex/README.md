

This folder contains dockerfiles to build Server GPU Flex software stack for Intel(R) Xeon(R) -SP or -D scalable processors with processor graphics. These are meant to be run on [Intel(R) Data Center GPU Flex series](https://www.intel.in/content/www/in/en/products/docs/discrete-gpus/data-center-gpu/flex-series/overview.html).

### Setup host platform:

Refer to below instructions to setup host platform:
- Install GPU and setup instructions (see [here](https://www.intel.com/content/www/us/en/developer/platform/data-center-gpu-flex.html#gs.mof7wp))

- Installing the docker.ce service (see [../README.md](../README.md).)

### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|media-dev|[ubuntu-20.04/media/dev](ubuntu-20.04/media/dev)<br>[ubuntu-22.04/media/dev](ubuntu-22.04/media/dev)|[openvisualcloud/flex-ubuntu2004-media-dev](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2004-media-dev)<br>[openvisualcloud/flex-ubuntu2204-media-dev](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2204-media-dev)|
|media-ffmpeg|[ubuntu-20.04/media/ffmpeg](ubuntu-20.04/media/ffmpeg)<br>[ubuntu-22.04/media/ffmpeg](ubuntu-22.04/media/ffmpeg)|[openvisualcloud/flex-ubuntu2004-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2004-media-ffmpeg)<br>[openvisualcloud/flex-ubuntu2204-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2204-media-ffmpeg)|
|analytics-dev|[ubuntu-20.04/analytics/dev](ubuntu-20.04/analytics/dev)<br>[ubuntu-22.04/analytics/dev](ubuntu-22.04/analytics/dev)|[openvisualcloud/flex-ubuntu2004-analytics-dev](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2004-analytics-dev)<br>[openvisualcloud/flex-ubuntu2204-analytics-dev](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2204-analytics-dev)|
|analytics-gst|[ubuntu-20.04/analytics/gst](ubuntu-20.04/analytics/gst)<br>[ubuntu-22.04/analytics/gst](ubuntu-22.04/analytics/gst)|[openvisualcloud/flex-ubuntu2004-analytics-gst](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2004-analytics-gst)<br>[openvisualcloud/flex-ubuntu2204-analytics-gst](https://hub.docker.com/r/openvisualcloud/flex-ubuntu2204-analytics-gst)|
