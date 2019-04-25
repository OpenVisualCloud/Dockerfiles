# Open Visual Cloud Dockerfiles
[![Travis Build Status](https://travis-ci.com/OpenVisualCloud/Dockerfiles.svg?branch=master)](https://travis-ci.com/OpenVisualCloud/Dockerfiles)
[![Stable release](https://img.shields.io/badge/latest_release-v1.0-green.svg)](https://github.com/OpenVisualCloud/Dockerfiles/releases/tag/v1.0)
[![License](https://img.shields.io/badge/license-BSD_3_Clause-green.svg)](https://github.com/OpenVisualCloud/Dockerfiles/blob/master/LICENSE)
[![Contributions](https://img.shields.io/badge/contributions-welcome-blue.svg)](https://github.com/OpenVisualCloud/Dockerfiles/wiki)

This repository hosts docker build files for multiple platform/OS/image combinations. Each image is tagged with development status.

Image:
- [FFmpeg](doc/ffmpeg.md): image optimized for media creation and delivery. Included codecs: aac, mp3, opus, ogg, vorbis, x264, x265, vp8/9, av1 and SVT-HEVC. The GPU images are accelerated with vaapi and qsv. See [ffmpeg.md](doc/ffmpeg.md) for details.
- [GStreamer](doc/gst.md): image optimized for media creation and delivery. Included the base, good, bad, ugly and libav set of plugins. The GPU images are accelerated with vaapi. See [gst.md](doc/gst.md) for details.
- [DLDT+FFmpeg](doc/ffmpeg.md): image optimized for media analytics. Included what are in the FFmpeg image. Inferencing engine and tracking plugins to be included. See [ffmpeg.md](doc/ffmpeg.md) for details.
- [DLDT+GStreamer](doc/gst.md): image optimized for media analytics. Included what are in the GStreamer image. Inferencing engine and tracking plugins to be included. See [gst.md](doc/gst.md) for details.
- [FFmpeg](doc/ffmpeg.md)+[GStreamer](doc/gst.md) (Dev): FFmpeg + GStreamer + C++ development files. Model optimizer to be included. See [ffmpeg.md](doc/ffmpeg.md) and [gst.md](doc/gst.md) for details.
- [NGINX+RTMP](doc/nginx.md): image optimized for web hosting and caching. Based on FFmpeg, included NGINX the web server and RTMP the RTMP, DASH and HLS streaming module. See [nginx.md](doc/nginx.md) for details.
- [ospray](doc/ospray.md): image optimized for intel ray tracing api. Based on embree, included ospray Ray Tracing engine and examples. See [ospray.md](doc/ospray.md) for details.
- [ospray+OpenImageIO+mpi](doc/ospray+OpenImageIO+mpi.md): image optimized for intel ray tracing api. Based on embree, included ospray Ray Tracing engine with examples(which require OpenImageIO) and multi-host connection via MPI. See [ospray+OpenImageIO+mpi.md](ospray+OpenImageIO+mpi.md) for details.

Status:
- C: Compiled. Not yet tested.
- T: Tested. Some tests failed.
- V: Verified. All tests passed.
- -: To be added in subsequent commits.

| Platform: Xeon (CPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| FFmpeg | V | V | V | V | V |
| GStreamer | V | V | V | V | V |
| DLDT(IE)+FFmpeg | V | V | V | V | V |
| DLDT(IE)+GStreamer | V | V | V | V | V |
| FFmpeg+GStreamer (Dev) | V | V | V | V | V |
| NGINX+RTMP | V | V | V | V | V |
| ospray | V | V | V | V | V |
| ospray+OpenImageIO+mpi | V | V | V | V | V |

| Platform: VCA2 | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| FFmpeg | V | V | V | V | V |
| GStreamer | V | V | T | T | T | 
| FFmpeg+GStreamer (Dev) | V | V | T | T | T |
| NGINX+RTMP | V | V | V | V | V |

| Platform: XeonE3 (GPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| FFmpeg | V | V | V | V | V |
| GStreamer | V | V | V | V | V |
| DLDT(IE)+GStreamer | V | V | V | V | V |
| FFmpeg+GStreamer (Dev) | V | V | V | V | V |
| NGINX+RTMP | V | V | V | V | V |

### Update kernel and firmware:    

Please see each platform folder README for the platform setup instructions.
   
### Install docker.ce:        

Follow the [instructions](https://docs.docker.com/install) to install docker.ce.

### Setup docker proxy:

If you are behind a firewall, setup proxy as follows:

```bash
(1) sudo mkdir -p /etc/systemd/system/docker.service.d    
(2) printf "[Service]\nEnvironment=\"HTTPS_PROXY=$https_proxy\" \"NO_PROXY=$no_proxy\"\n" | sudo tee /etc/systemd/system/docker.service.d/proxy.conf    
(3) sudo systemctl daemon-reload     
(4) sudo systemctl restart docker     
```

#### Pre-requisites:
Host system needs to correctly setup in order for certain repos to reachable. Refer [this](https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-18-04 "this") link.

### Build docker image(s): 

```bash
(1) mkdir build    
(2) cd build     
(3) cmake ..    
(4) cd Xeon/ubuntu-16.04/ffmpeg # please build your specific <_platform_>/<_OS_>/<_image_> only as a full build takes a long time.     
(5) make # build on the target processor for best performance.    
(6) ctest   
```

### Run shell:

```bash
Xeon/ubuntu-16.04/ffmpeg/shell.sh #<_platform_>/<_OS_>/<_image_>
```

### Customize:

You can modify any Dockerfile.m4 template for customization.     
For example, uncomment #include(transform360.m4) in Xeon/ubuntu-16.04/ffmpeg/Dockerfile.m4 to add essential 360 video transformation in the FFmpeg build.    
After modification, please rerun cmake and make.     

### Use alternative repo:

Certain source repo might be blocked in certain network. You can specify alternative repos before the build command as follows:

```bash
export AOM_REPO=...       
export VPX_REPO=...     
make
```

For a list of all REPOs and their versions, run the following command:

```bash
grep -E '_(REPO|VER)=' template/*.m4         
```

### Use Dockerfile(s) in other project:

It is recommended that you copy the Dockerfile(s) of your platform, OS and image directly into your other project. The following shell scripts show how to sync (if needed) and build the NGINX+RTMP Dockerfile (and its dependency FFmpeg):

update.sh:   
```bash
DOCKER_REPO=${DOCKER_REPO="https://raw.githubusercontent.com/OpenVisualCloud/Dockerfiles/master/Xeon/ubuntu-18.04"}    
(echo "# xeon-ubuntu1804-ffmpeg" && curl ${DOCKER_REPO}/ffmpeg/Dockerfile) > Dockerfile.2    
(echo "# xeon-ubuntu1804-nginx-rtmp" && curl ${DOCKER_REPO}/nginx+rtmp/Dockerfile) > Dockerfile.1    
```
build.sh:   
```bash
for dep in .2 .1; do   
    image=$(grep -m1 '#' "Dockerfile$dep" | cut -d' ' -f2)   
    sudo docker build --network=host --file="Dockerfile$dep" -t "$image:latest" . $(env | grep -E '_(proxy)=' | sed 's/^/--build-arg /')   
done  
```
