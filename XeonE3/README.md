
This folder contains docker files to build CPU and GPU software stack for Intel(R) Xeon(R) -SP or -D scalable processors with processor graphics.

### Setup host platform:

The host platform includes updating kernel and installing the docker.ce service (see [../README.md](../README.md).)

### Update kernel:      

Kernel version 4.18 or later is recommended for feature and performance. The following is the procedure to update to a custom kernel:    

|  Ubuntu | CentOS |
|:--------|:-------|
|(1) sudo apt-get install -y bison flex libssl-dev libelf-dev |(1) sudo yum install -y bison flex openssl-devel elfutils-libelf-devel |

<br>     

(2) wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.18.16.tar.xz | tar xJ         
(3) cd linux-4.18.16    
(4) make olddefconfig    
(5) make -j8    
(6) sudo make modules_install    
(7) sudo make install   
(8) sudo update-grub   
(9) sudo shutdown -r now   

### GPU Dockers:

VAAPI expects rendering device to be set in order to work. Dockers readily spin up with this config. Setup host with these instructions to be able to run vaapi based plugins successfully:

 - Install X11 server utils on the host<br>
```sudo apt-get install x11-xserver-utils```

 - Modify ```/etc/lightdm/lightdm.conf``` and restart the service<br>
   - ```cat /etc/lightdm/lightdm.conf```<br>
[SeatDefaults]<br>
autologin-user=<SYSTEM_USER_NAME>

   - ```sudo systemctl restart lightdm```
 - Define display device in the environment if not already<br>
 ```export DISPLAY=:0.0```
 - Allow any user to connect to XServer<br>
 ```xhost +```
- Add ```-v /tmp/.X11-unix:/tmp/.X11-unix``` in docker run command when running the docker


### Docker Images:

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|analytics-dev|[centos-7/analytics/dev](centos-7/analytics/dev)<br>[ubuntu-18.04/analytics/dev](ubuntu-18.04/analytics/dev)<br>[ubuntu-20.04/analytics/dev](ubuntu-20.04/analytics/dev)|[openvisualcloud/xeone3-centos7-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-analytics-dev)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-dev)<br>[openvisualcloud/xeone3-ubuntu2004-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-analytics-dev)|
|analytics-ffmpeg|[centos-7/analytics/ffmpeg](centos-7/analytics/ffmpeg)<br>[ubuntu-18.04/analytics/ffmpeg](ubuntu-18.04/analytics/ffmpeg)<br>[ubuntu-20.04/analytics/ffmpeg](ubuntu-20.04/analytics/ffmpeg)|[openvisualcloud/xeone3-centos7-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-analytics-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu2004-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-analytics-ffmpeg)|
|analytics-gst|[centos-7/analytics/gst](centos-7/analytics/gst)<br>[ubuntu-18.04/analytics/gst](ubuntu-18.04/analytics/gst)<br>[ubuntu-20.04/analytics/gst](ubuntu-20.04/analytics/gst)|[openvisualcloud/xeone3-centos7-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-analytics-gst)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-gst)<br>[openvisualcloud/xeone3-ubuntu2004-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-analytics-gst)|
|media-dev|[centos-7/media/dev](centos-7/media/dev)<br>[ubuntu-18.04/media/dev](ubuntu-18.04/media/dev)<br>[ubuntu-20.04/media/dev](ubuntu-20.04/media/dev)|[openvisualcloud/xeone3-centos7-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-media-dev)<br>[openvisualcloud/xeone3-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-dev)<br>[openvisualcloud/xeone3-ubuntu2004-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-media-dev)|
|media-ffmpeg|[centos-7/media/ffmpeg](centos-7/media/ffmpeg)<br>[ubuntu-18.04/media/ffmpeg](ubuntu-18.04/media/ffmpeg)<br>[ubuntu-20.04/media/ffmpeg](ubuntu-20.04/media/ffmpeg)|[openvisualcloud/xeone3-centos7-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-media-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu2004-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-media-ffmpeg)|
|media-gst|[centos-7/media/gst](centos-7/media/gst)<br>[ubuntu-18.04/media/gst](ubuntu-18.04/media/gst)<br>[ubuntu-20.04/media/gst](ubuntu-20.04/media/gst)|[openvisualcloud/xeone3-centos7-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-media-gst)<br>[openvisualcloud/xeone3-ubuntu1804-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-gst)<br>[openvisualcloud/xeone3-ubuntu2004-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu2004-media-gst)|
|media-nginx|[centos-7/media/nginx](centos-7/media/nginx)<br>[ubuntu-18.04/media/nginx](ubuntu-18.04/media/nginx)|[openvisualcloud/xeone3-centos7-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-media-nginx)<br>[openvisualcloud/xeone3-ubuntu1804-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-nginx)|
|service-owt-dev|[centos-7/service/owt-dev](centos-7/service/owt-dev)<br>[ubuntu-18.04/service/owt-dev](ubuntu-18.04/service/owt-dev)|[openvisualcloud/xeone3-centos7-service-owt-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-service-owt-dev)<br>[openvisualcloud/xeone3-ubuntu1804-service-owt-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-service-owt-dev)|
|service-owt|[centos-7/service/owt](centos-7/service/owt)<br>[ubuntu-18.04/service/owt](ubuntu-18.04/service/owt)|[openvisualcloud/xeone3-centos7-service-owt](https://hub.docker.com/r/openvisualcloud/xeone3-centos7-service-owt)<br>[openvisualcloud/xeone3-ubuntu1804-service-owt](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-service-owt)|
|service-owt360|[centos-7/service/owt360](centos-7/service/owt360)<br>[ubuntu-18.04/service/owt360](ubuntu-18.04/service/owt360)|[openvisualcloud/xeone3-centos76-service-owt360](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-service-owt360)<br>[openvisualcloud/xeone3-ubuntu1804-service-owt360](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-service-owt360)|
