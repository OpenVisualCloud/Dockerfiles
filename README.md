This repository hosts docker build files for multiple platform/OS/image combinations. Each image is tagged with development status.

Image:
- FFmpeg: image optimized for media creation and delivery. Included codecs: aac, mp3, opus, ogg, vorbis, x264, x265, vp8/9, av1 and SVT-HEVC. The GPU images are accelerated with vaapi and qsv.
- GStreamer: image optimized for media creation and delivery. Included the base, good, bad, ugly and libav set of plugins. The GPU images are accelerated with vaapi.
- DLDT+FFmpeg: image optimized for media analytics. Included what are in the FFmpeg image. Inferencing engine and tracking plugins to be included.
- DLDT+GStreamer: image optimized for media analytics. Included what are in the GStreamer image. Inferencing engine and tracking plugins to be included.
- FFmpeg+GStreamer (Dev): FFmpeg + GStreamer + C++ development files. Model optimizer to be included.
- NGINX+RTMP: image optimized for web hosting and caching. Based on FFmpeg, included NGINX the web server and RTMP the RTMP, DASH and HLS streaming module.

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

| Platform: VCA2 | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| FFmpeg | V | V | - | V | V |
| GStreamer | C | C | - | C | C | 
| FFmpeg+GStreamer (Dev) | T | T | - | T | T |
| NGINX+RTMP | V | V | - | V | V |

| Platform: XeonE3 (GPU) | Ubuntu 16.04 LTS | Ubuntu 18.04 LTS | CentOS-7.4 | CentOS-7.5 | CentOS-7.6 |
|-----|:---:|:---:|:---:|:---:|:---:|
| FFmpeg | V | V | V | V | V |
| GStreamer | C | C | C | C | C |
| FFmpeg+GStreamer (Dev) | C | C | C | C | C |
| NGINX+RTMP | V | V | V | V | V |

### Update kernel and firmware:    

Please see each platform folder README for the platform setup instructions.
   
### Install docker.ce:        
| Ubuntu    | CentOS |
|:----------|:----------------|
|(0) sudo apt-get remove docker.io # remove old docker |(0) sudo yum remove docker docker-engine # remove old docker |    
|(1) curl -fsSL https://download.docker.com/linux/ubuntu/gpg \| sudo apt-key add - |(1) sudo yum install -y yum-utils device-mapper-persistent-data lvm2 |
|(2) sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |(2) sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo |
|(3) sudo apt-get update && sudo apt-get install -y docker-ce |(3) sudo yum install -y docker-ce |


### Setup docker proxy:
```bash
(4) sudo mkdir -p /etc/systemd/system/docker.service.d    
(5) printf "[Service]\nEnvironment=\"HTTPS_PROXY=$https_proxy\" \"NO_PROXY=$no_proxy\"\n" | sudo tee /etc/systemd/system/docker.service.d/proxy.conf    
(6) sudo systemctl daemon-reload     
(7) sudo systemctl restart docker     
```

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
(1) Xeon/ubuntu-16.04/ffmpeg/shell.sh #<_platform_>/<_OS_>/<_image_>
```

### Customize:

You can modify any Dockerfile.m4 template for customization. For example, uncomment #include(transform360.m4) in Xeon/ubuntu-16.04/ffmpeg/Dockerfile.m4 to add essential 360 video transformation in the FFmpeg build.    
After modification, please rerun cmake and make.     

### Use alternative repo:

Certain source repo might be blocked in certain network. You can use alternative repos before build as follows:

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
DOCKER_REPO=${DOCKER_REPO="https://<<this-repo>>/master/raw/Xeon/ubuntu-18.04"}    
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






