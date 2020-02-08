
Enhance security and compression performance in cloud, networking, big data, and storage applications — for data in motion and at rest. Now you can accelerate compute-intensive operations with Intel<sup>&reg;</sup> QuickAssist Technology (Intel QAT).   

This document describes the system setup to use Intel QAT within docker containers.  

### Install Driver and Service:

- Follow the [instructions](https://01.org/sites/default/files/downloads//336212-006qatsw-gettingstarted.pdf) to install the supported OS, kernel, Intel QAT driver and service on the host. For CentOS 7.6, the steps are as follows:   

```bash
sudo yum update
printf '[intel-qat]\nname=Intel QAT\nbaseurl=https://download.01.org/QAT/repo\ngpgcheck=0\n' | sudo tee /etc/yum.repos.d/intel-qat.repo
sudo yum clean all
sudo yum install -y QAT
sudo systemctl start qat_service
sudo systemctl enable qat_service
```

- Enable kernel hugepage support:  

```bash
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
sudo systemctl restart qat_service
```

### Configure QATzip and QATengine:

QATzip is a utility (`qzip`) for data compression. QATengine is a crypto engine that can be used in the openssl framework. The async mode NGINX requires both QATzip and QATengine.   

While the docker images contain QATzip and QATengine, you **must** configure QATzip and QATengine on each host that the containers run. The QATzip configuration files are located at [QATzip/config_file](https://github.com/intel/QATzip/tree/master/config_file) and the QATengine configuration files are located at [QATengine/qat/config](https://github.com/intel/QAT_Engine/tree/master/qat/config). 

There are multiple versions of the configuration files optimized for different adpaters and usage scenarios. Select the ones that meet your adapter and usage pattern. Copy them to the `/etc` directory. Note that QATzip looks for `NumberDcInstances` and QATengine looks for `NumberCyInstances`. Thus you will need to merge the QATzip and QATengine configuration files together as you need both in NGINX.    

For example, `/etc/c6xx_dev0.conf` might look similar to the following:  

```
##############################################
# User Process Instance Section
##############################################
[SHIM]
NumberCyInstances = 1
NumberDcInstances = 1
NumProcesses = 32
LimitDevAccess = 1

# Data Compression - User instance #0
Dc0Name = "Dc0"
Dc0IsPolled = 1
# List of core affinities
Dc0CoreAffinity = 1

# Crypto - User instance #0
Cy0Name = "Cy0"
Cy0IsPolled = 1
# List of core affinities
Cy0CoreAffinity = 1
```

Finally, restart the `qat_service` to initialize the configuration files:   

```bash
sudo systemctl restart qat_service
```

### Run Docker Images: 

The docker images **must** run with the following devices/configuration files attached:  
- `/etc/*_dev?.conf`: The configuration files for QATzip and QATengine.   
- `/dev/hugepages`: The hugepage kernel pages.  
- `/dev/uio*`: The uio devices.  
- `/dev/qat_*`: The qat devices.  
- `/dev/usdm_drv`: The usdm device.  

For example, run the following script to start the NGINX Ubuntu image:   

```bash
docker run $(ls -1 -d /etc/*_dev?.conf /dev/hugepages | sed 's/\(.*\)/-v \1:\1/') $(ls -1 /dev/uio* /dev/qat_* /dev/usdm_drv | sed 's/\(.*\)/--device=\1:\1/') -it openvisualcloud/qat-ubuntu1804-media-nginx
```

### Run Docker Images as Non-Root:

To run the docker images as a non-root user, you need to create a `qat` group and make your user part of the `qat` group. The GID of the `qat` group within the containers **must** match that of the `qat` group on the host.   

### Known Limitations:   

- The docker images must be built and tested on the host with Intel QAT installed.  

### See Also:

- [Intel QuickAssist Technology](https://01.org/intel-quickassist-technology)   
- [QATzip](https://github.com/intel/QATzip)   
- [QATengine](https://github.com/intel/QAT_Engine)   
- [Async Mode Nginx](https://github.com/intel/asynch_mode_nginx)  


