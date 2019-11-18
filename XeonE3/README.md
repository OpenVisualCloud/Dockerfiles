
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

### For GStreamer dockers
VAAPI expects rendering device to be set in order to work. Dockers readily spin up with this config.
Setup host with these instructions to be able to run vaapi based plugins successfully:

 

 - Install X11 server utils on the host<br>
```sudo apt-get install x11-xserver-utils```

 - Modify ```/etc/lightdm/lightdm.conf``` and restart the service<br>
   - ```cat /etc/lightdm/lightdm.conf```<br>
[SeatDefaults]<br>
autologin-user=<SYSTEM_USER_NAME>

   - ```sudo systemctl restart lightdm```
 - Allow any user to connect to XServer<br>
 ```xhost +```
- Add ```-v /tmp/.X11-unix:/tmp/.X11-unix``` in docker run command when running the docker

