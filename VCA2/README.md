The Intel(R) Visual Compute Accelerator 2 (Intel VCA 2) features three Intel(R) Xeon(R) processors E3-1500 v5 with Iris(R) Pro P580.    

See the following documents for instructions on how to setup Intel VCA 2: 
- [Intel VCA 2 Product Specification and Hardware Guide](https://www.intel.com/content/dam/support/us/en/documents/server-products/server-accessories/VCA2_HW_User_Guide.pdf)
- [Intel VCA 2 Product Family Software Guide](https://www.intel.com/content/dam/support/us/en/documents/server-products/server-accessories/VCA_SoftwareUserGuide.pdf)

The Dockerfiles presented in this repo are targeted to run on the Intel VCA 2 nodes. Therefore the host installation steps mentioned in the parent [README.md](../README.md) apply to each Intel VCA 2 node instead. 

### GPU Dockers:

VAAPI expects rendering device to be set in order to work. Dockers readily spin up with this config. Specify the display device on host by doing following.

```bash
apt-get install xdm xinit
startx
```

On second window
```bash
export DISPLAY=:0.0
```

Note: If the host is not connected with a display, it may need to run "xhost +" on host to allow docker session connecting to host X server.

### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|	
|media-dev|[centos-7/media/dev](centos-7/media/dev)<br>[ubuntu-16.04/media/dev](ubuntu-16.04/media/dev)<br>[ubuntu-18.04/media/dev](ubuntu-18.04/media/dev)|[openvisualcloud/vca2-centos7-media-dev](https://hub.docker.com/r/openvisualcloud/vca2-centos7-media-dev)<br>[openvisualcloud/vca2-ubuntu1604-media-dev](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1604-media-dev)<br>[openvisualcloud/vca2-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1804-media-dev)|	
|media-ffmpeg|[centos-7/media/ffmpeg](centos-7/media/ffmpeg)<br>[ubuntu-16.04/media/ffmpeg](ubuntu-16.04/media/ffmpeg)<br>[ubuntu-18.04/media/ffmpeg](ubuntu-18.04/media/ffmpeg)|[openvisualcloud/vca2-centos7-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/vca2-centos7-media-ffmpeg)<br>[openvisualcloud/vca2-ubuntu1604-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1604-media-ffmpeg)<br>[openvisualcloud/vca2-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1804-media-ffmpeg)|	
|media-gst|[centos-7/media/gst](centos-7/media/gst)<br>[ubuntu-16.04/media/gst](ubuntu-16.04/media/gst)<br>[ubuntu-18.04/media/gst](ubuntu-18.04/media/gst)|[openvisualcloud/vca2-centos7-media-gst](https://hub.docker.com/r/openvisualcloud/vca2-centos7-media-gst)<br>[openvisualcloud/vca2-ubuntu1604-media-gst](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1604-media-gst)<br>[openvisualcloud/vca2-ubuntu1804-media-gst](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1804-media-gst)|	
|media-nginx|[centos-7/media/nginx](centos-7/media/nginx)<br>[ubuntu-16.04/media/nginx](ubuntu-16.04/media/nginx)<br>[ubuntu-18.04/media/nginx](ubuntu-18.04/media/nginx)|[openvisualcloud/vca2-centos7-media-nginx](https://hub.docker.com/r/openvisualcloud/vca2-centos7-media-nginx)<br>[openvisualcloud/vca2-ubuntu1604-media-nginx](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1604-media-nginx)<br>[openvisualcloud/vca2-ubuntu1804-media-nginx](https://hub.docker.com/r/openvisualcloud/vca2-ubuntu1804-media-nginx)|
