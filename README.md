# ![logo][]  Software Stack Dockerfiles
[![HOMEPAGE](https://img.shields.io/badge/Homepage-01.org-brightblue.svg)](https://01.org/OpenVisualCloud)
[![Dockerhub](https://img.shields.io/badge/Images-Dockerhub-blue.svg)](https://hub.docker.com/u/openvisualcloud)
[![Stable release](https://img.shields.io/badge/Release-Latest-green.svg)](https://github.com/OpenVisualCloud/Dockerfiles/releases/latest)
[![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange.svg)](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

[logo]: https://avatars3.githubusercontent.com/u/46843401?s=90&v=4

This repository hosts docker build files of software stacks and services, designed to enable Open Visual Cloud prioritized use cases such as media delivery, media analytics, cloud gaming and cloud graphics, and immersive media.

---

Validated docker images are available on [**Docker Hub**](https://hub.docker.com/u/openvisualcloud).

---

### Software Stack Images:

The software stack images provide ready to use software stacks for application deployment. You can call the software executables or link with the software libraries.   

- **Media Delivery**

| Image | Description |
| :-----: | ----- | 
| [ffmpeg](doc/ffmpeg.md) | <p>Docker images optimized for media creation and delivery based on the FFmpeg framework. Included the AAC, MP3, OPUS, OGG, Vorbis, X264, X265, VP8/9, AV1 and SVT-HEVC codecs. The GPU images are accelerated with VAAPI and QSV. See [`doc/ffmpeg.md`](doc/ffmpeg.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-ffmpeg)<br>docker pull [openvisualcloud/xeon-centos76-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-centos76-media-ffmpeg)|
| [gst](doc/gst.md) | <p>Docker images optimized for media creation and delivery based on the GStreamer framework. Included the base, good, bad, ugly and libav set of plugins. The GPU images are accelerated with VAAPI. See [`doc/gst.md`](doc/gst.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-gst)<br>docker pull [openvisualcloud/xeon-centos76-media-gst](https://hub.docker.com/r/openvisualcloud/xeon-centos76-media-gst)|
| [nginx](doc/nginx.md) | <p>Docker images optimized for web hosting and caching. Included FFmpeg, NGINX the web server, and FLV the RTMP and DASH/HLS streaming module. See [`doc/nginx.md`](doc/nginx.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-nginx)<br>docker pull [openvisualcloud/xeon-centos76-media-nginx](https://hub.docker.com/r/openvisualcloud/xeon-centos76-media-nginx)|
| [svt](doc/svt.md) | <p>Docker images for the SVT (Scalable Video Technology) encoders and decoders. Easiest way to try SVT AV1, HEVC, and VP9 apps. See [`doc/svt.md`](doc/svt.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-svt)<br>docker pull [openvisualcloud/xeon-centos76-media-svt](https://hub.docker.com/r/openvisualcloud/xeon-centos76-media-svt)|

- **Media Analytics**   

| Image | Description |
| :-----: | :----- | 
| [ffmpeg](doc/ffmpeg.md) | <p>Docker images optimized for media analytics based on the FFmpeg framework. Included plugins that utilized the Intel<sup>&reg;</sup> OpenVINO<sup>&trade;</sup> inference engine. See [`doc/ffmpeg.md`](doc/ffmpeg.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-ffmpeg)<br>docker pull [openvisualcloud/xeon-centos76-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeon-centos76-analytics-ffmpeg)|
| [gst](doc/gst.md) | <p>Docker images optimized for media analytics based on the GStreamer framework. Included plugins that utilized the Intel OpenVINO inference engine. See [`doc/gst.md`](doc/gst.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-gst)<br>docker pull [openvisualcloud/xeon-centos76-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeon-centos76-analytics-gst)|

- **Cloud Gaming and Graphics**

| Image | Description |
| :-----: | :----- |
| [ospray](doc/ospray.md) | <p>Docker images optimized for Intel OSPRay. Included the Intel OSPRay ray tracing engine and examples. See [`doc/ospray.md`](doc/ospray.md) for additional details.</p>|
| [ospray-mpi](doc/ospray-mpi.md) | <p>Docker images optimized for Intel OSPRay and multi-host connections. Included the Intel OSPRay ray tracing engine with multi-host connections via MPI. See [`doc/ospray-mpi.md`](doc/ospray-mpi.md) for additional details.</p>|

### Development Images:

The development images enable C++ application compilation, debugging (with the debugging, profiling tools) and optimization (with the optimization tools.) You can compile C++ applications with these images and then copy the applications to the corresponding deployment images.

| Image | Description |
| :-----: | :----- |
| media | <p>Docker images for FFmpeg or GStreamer C++ application development. See [`doc/ffmpeg.md`](doc/ffmpeg.md) and [`doc/gst.md`](doc/gst.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-media-dev)<br>docker pull [openvisualcloud/xeon-centos76-media-dev](https://hub.docker.com/r/openvisualcloud/xeon-centos76-media-dev)|
| analytics | <p>Docker images for FFmpeg or GStreamer C++ application development, with Intel OpenVINO inference engine and the model optimizer. See [`doc/ffmpeg.md`](doc/ffmpeg.md) and [`doc/gst.md`](doc/gst.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-dev)<br>docker pull [openvisualcloud/xeon-centos76-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeon-centos76-analytics-dev)|
| graphics | <p>Docker image for Intel OSPRay C++ application development. See [`doc/ospray-mpi.md`](doc/ospray-mpi.md) for additional details.</p>|

### Service Images:

The service images provides ready to use services. See their image descriptions for exposed service interfaces.    

| Image | Description |
| :-----: | :----- | 
| [owt](doc/owt.md)| <p>Docker images optimized for video conferencing services, based on the WebRTC technology and the Open WebRTC Toolkit. Included conferencing modes: 1:N, N:N with video and audio processing nodes. see [`doc/owt.md`](doc/owt.md) for additional details.</p>docker pull [openvisualcloud/xeon-ubuntu1804-service-owt](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-service-owt)<br>docker pull [openvisualcloud/xeon-centos76-service-owt](https://hub.docker.com/r/openvisualcloud/xeon-centos76-service-owt)|
| [owt-immersive](doc/owt-immersive.md)| <p>Docker images optimized for ultra-high resolution immersive video low latency streaming, based on the WebRTC technology and the Open WebRTC Toolkit. Included SVT-HEVC tile-based 4K and 8K transcoding and field of view (FoV) adaptive streaming. see [`doc/owt-immersive.md`](doc/owt-immersive.md) for additional details.</p>|

### Support Matrix:

The project supports the following platforms and OS'es:

| Supported Platforms | Supported OS'es |
| :---: | :--- |
| [Xeon](Xeon) | Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, CentOS 7.4-7.6 |
| [Xeon E3](XeonE3) | Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, CentOS 7.4-7.6 |
| [VCA2](VCA2) | Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, CentOS 7.4-7.6 |
| [VCAC-A](VCAC-A) | Ubuntu 16.04 LTS, Ubuntu 18.04 LTS |
| [QAT](QAT) | Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, CentOS 7.4-7.6 |

Please see [Development and Test Report](doc/test.md) for the latest development statuses.    

### Host Platform Setup:

- Update kernels and firmwares: Please see each platform folder README for details.    
- Install `cmake` and `m4` if they are not available on your platform.  
- Make sure your host datetime and timezone are configured properly, a prerequisite to install any Ubuntu security updates.     
- Follow the [instructions](https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-18-04) to setup host date and time.
- Follow the [instructions](https://docs.docker.com/install) to install docker.ce or docker.ee.    
- If you are behind a firewall, setup proxy as follows:    

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d    
printf "[Service]\nEnvironment=\"HTTPS_PROXY=$https_proxy\" \"NO_PROXY=$no_proxy\"\n" | sudo tee /etc/systemd/system/docker.service.d/proxy.conf    
sudo systemctl daemon-reload     
sudo systemctl restart docker     
```

### Evaluate Image:

The docker images are published on [Docker Hub](https://hub.docker.com/u/openvisualcloud) with name pattern ```openvisualcloud/<_platform_>-<_OS_>-<_usage_>-<_image_>```. Find and use the images as follows:  

```bash
docker search openvisualcloud --limit=100 | grep analytics-ffmpeg #list media analytics ffmpeg images 
docker pull openvisualcloud/xeon-ubuntu1604-analytics-ffmpeg
```

### Build Image: 

```bash
mkdir build    
cd build     
cmake ..     
# Please build your specific platform image. A full build takes a long time.
cd Xeon/ubuntu-16.04/media/ffmpeg     
# Build on the target platform for optimal performance.
make    
ctest   
```
See Also: [Build Options](doc/cmake.md)

### Run Image Shell:

```bash
Xeon/ubuntu-16.04/media/ffmpeg/shell.sh #<_platform_>/<_OS_>/<_usage_>/<_image_>
```

### Customize Image:

- You can modify any ```Dockerfile.m4``` template for customization.     
For example, uncomment ```#include(transform360.m4)``` in [Xeon/ubuntu-16.04/media/ffmpeg/Dockerfile.m4](Xeon/ubuntu-16.04/media/ffmpeg/Dockerfile.m4) to add essential 360 video transformation in the FFmpeg build.    

After modification, please rerun cmake and make.     

See Also: [Build Options](doc/cmake.md)

### Use Dockerfile(s) in Your Project:

It is recommended that you copy the Dockerfile(s) of your platform, OS and image directly into your project. The following shell scripts show how to sync (if needed) and build the NGINX Dockerfile (and its dependency FFmpeg):

update.sh:   
```bash
DOCKER_REPO=${DOCKER_REPO="https://raw.githubusercontent.com/OpenVisualCloud/Dockerfiles/master/Xeon/ubuntu-18.04/media"}    
(echo "# xeon-ubuntu1804-media-ffmpeg" && curl ${DOCKER_REPO}/ffmpeg/Dockerfile) > Dockerfile.2    
(echo "# xeon-ubuntu1804-media-nginx" && curl ${DOCKER_REPO}/nginx/Dockerfile) > Dockerfile.1    
```
build.sh:   
```bash
for dep in .2 .1; do   
    image=$(grep -m1 '#' "Dockerfile$dep" | cut -d' ' -f2)   
    sudo docker build --network=host --file="Dockerfile$dep" -t "$image:latest" . $(env | grep -E '_(proxy)=' | sed 's/^/--build-arg /')   
done  
```
