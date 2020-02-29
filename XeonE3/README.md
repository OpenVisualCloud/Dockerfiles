
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
|analytics-dev|[centos-7.4/analytics/dev](centos-7.4/analytics/dev)<br>[centos-7.5/analytics/dev](centos-7.5/analytics/dev)<br>[centos-7.6/analytics/dev](centos-7.6/analytics/dev)<br>[ubuntu-16.04/analytics/dev](ubuntu-16.04/analytics/dev)<br>[ubuntu-18.04/analytics/dev](ubuntu-18.04/analytics/dev)|[openvisualcloud/xeone3-centos74-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-analytics-dev)<br>[openvisualcloud/xeone3-centos75-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-analytics-dev)<br>[openvisualcloud/xeone3-centos76-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-analytics-dev)<br>[openvisualcloud/xeone3-ubuntu1604-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-analytics-dev)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-dev)|
|analytics-ffmpeg|[centos-7.4/analytics/ffmpeg](centos-7.4/analytics/ffmpeg)<br>[centos-7.5/analytics/ffmpeg](centos-7.5/analytics/ffmpeg)<br>[centos-7.6/analytics/ffmpeg](centos-7.6/analytics/ffmpeg)<br>[ubuntu-16.04/analytics/ffmpeg](ubuntu-16.04/analytics/ffmpeg)<br>[ubuntu-18.04/analytics/ffmpeg](ubuntu-18.04/analytics/ffmpeg)|[openvisualcloud/xeone3-centos74-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-analytics-ffmpeg)<br>[openvisualcloud/xeone3-centos75-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-analytics-ffmpeg)<br>[openvisualcloud/xeone3-centos76-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-analytics-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1604-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-analytics-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-ffmpeg)|
|analytics-gst|[centos-7.4/analytics/gst](centos-7.4/analytics/gst)<br>[centos-7.5/analytics/gst](centos-7.5/analytics/gst)<br>[centos-7.6/analytics/gst](centos-7.6/analytics/gst)<br>[ubuntu-16.04/analytics/gst](ubuntu-16.04/analytics/gst)<br>[ubuntu-18.04/analytics/gst](ubuntu-18.04/analytics/gst)|[openvisualcloud/xeone3-centos74-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-analytics-gst)<br>[openvisualcloud/xeone3-centos75-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-analytics-gst)<br>[openvisualcloud/xeone3-centos76-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-analytics-gst)<br>[openvisualcloud/xeone3-ubuntu1604-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-analytics-gst)<br>[openvisualcloud/xeone3-ubuntu1804-analytics-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-analytics-gst)|
|media-dev|[centos-7.4/media/dev](centos-7.4/media/dev)<br>[centos-7.5/media/dev](centos-7.5/media/dev)<br>[centos-7.6/media/dev](centos-7.6/media/dev)<br>[ubuntu-16.04/media/dev](ubuntu-16.04/media/dev)<br>[ubuntu-18.04/media/dev](ubuntu-18.04/media/dev)|[openvisualcloud/xeone3-centos74-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-media-dev)<br>[openvisualcloud/xeone3-centos75-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-media-dev)<br>[openvisualcloud/xeone3-centos76-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-media-dev)<br>[openvisualcloud/xeone3-ubuntu1604-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-media-dev)<br>[openvisualcloud/xeone3-ubuntu1804-media-dev](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-dev)|
|media-ffmpeg|[centos-7.4/media/ffmpeg](centos-7.4/media/ffmpeg)<br>[centos-7.5/media/ffmpeg](centos-7.5/media/ffmpeg)<br>[centos-7.6/media/ffmpeg](centos-7.6/media/ffmpeg)<br>[ubuntu-16.04/media/ffmpeg](ubuntu-16.04/media/ffmpeg)<br>[ubuntu-18.04/media/ffmpeg](ubuntu-18.04/media/ffmpeg)|[openvisualcloud/xeone3-centos74-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-media-ffmpeg)<br>[openvisualcloud/xeone3-centos75-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-media-ffmpeg)<br>[openvisualcloud/xeone3-centos76-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-media-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1604-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-media-ffmpeg)<br>[openvisualcloud/xeone3-ubuntu1804-media-ffmpeg](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-ffmpeg)|
|media-gst|[centos-7.4/media/gst](centos-7.4/media/gst)<br>[centos-7.5/media/gst](centos-7.5/media/gst)<br>[centos-7.6/media/gst](centos-7.6/media/gst)<br>[ubuntu-16.04/media/gst](ubuntu-16.04/media/gst)<br>[ubuntu-18.04/media/gst](ubuntu-18.04/media/gst)|[openvisualcloud/xeone3-centos74-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-media-gst)<br>[openvisualcloud/xeone3-centos75-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-media-gst)<br>[openvisualcloud/xeone3-centos76-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-media-gst)<br>[openvisualcloud/xeone3-ubuntu1604-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-media-gst)<br>[openvisualcloud/xeone3-ubuntu1804-media-gst](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-gst)|
|media-nginx|[centos-7.4/media/nginx](centos-7.4/media/nginx)<br>[centos-7.5/media/nginx](centos-7.5/media/nginx)<br>[centos-7.6/media/nginx](centos-7.6/media/nginx)<br>[ubuntu-16.04/media/nginx](ubuntu-16.04/media/nginx)<br>[ubuntu-18.04/media/nginx](ubuntu-18.04/media/nginx)|[openvisualcloud/xeone3-centos74-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-centos74-media-nginx)<br>[openvisualcloud/xeone3-centos75-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-centos75-media-nginx)<br>[openvisualcloud/xeone3-centos76-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-media-nginx)<br>[openvisualcloud/xeone3-ubuntu1604-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1604-media-nginx)<br>[openvisualcloud/xeone3-ubuntu1804-media-nginx](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-media-nginx)|
|service-owt|[centos-7.6/service/owt](centos-7.6/service/owt)<br>[ubuntu-18.04/service/owt](ubuntu-18.04/service/owt)|[openvisualcloud/xeone3-centos76-service-owt](https://hub.docker.com/r/openvisualcloud/xeone3-centos76-service-owt)<br>[openvisualcloud/xeone3-ubuntu1804-service-owt](https://hub.docker.com/r/openvisualcloud/xeone3-ubuntu1804-service-owt)|


