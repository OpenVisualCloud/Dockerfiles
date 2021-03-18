
This folder contains dockerfiles to build Intel(R) CPU and Server GPU SG1 software stack for Intel(R) Xeon(R) -SP or -D scalable processors with processor graphics.

### Setup host platform:

Refer to below instructions to setup host platform:
- Updating Kernel and KMD [SG1 Platform Setup Guide](https://cdrdv2.intel.com/v1/dl/getContent/632320?wapkw=SG1)  

- Installing the docker.ce service (see [../README.md](../README.md).)

### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|media-dev|[centos-7/media/dev](centos-7/media/dev)<br>[ubuntu-18.04/media/dev](ubuntu-18.04/media/dev)<br>[ubuntu-20.04/media/dev](ubuntu-20.04/media/dev)|[openvisualcloud/sg1-centos7-media-dev](https://hub.docker.com/r/openvisualcloud/sg1-centos7-media-dev)<br>[openvisualcloud/sg1-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/sg1-ubuntu1804-media-dev)<br>[openvisualcloud/sg1-ubuntu2004-media-dev](https://hub.docker.com/r/openvisualcloud/sg1-ubuntu2004-media-dev)|
|media-ffmpeg|[centos-7/media/ffmpeg](centos-7/media/ffmpeg)<br>[ubuntu-18.04/media/ffmpeg](ubuntu-18.04/media/ffmpeg)<br>[ubuntu-20.04/media/ffmpeg](ubuntu-20.04/media/ffmpeg)|[openvisualcloud/sg1-centos7-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/sg1-centos7-media-ffmpeg)<br>[openvisualcloud/sg1-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/sg1-ubuntu1804-media-ffmpeg)<br>[openvisualcloud/sg1-ubuntu2004-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/sg1-ubuntu2004-media-ffmpeg)|
