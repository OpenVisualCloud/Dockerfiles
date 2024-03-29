

Enhance security and compression performance in cloud, networking, big data, and storage applications — for data in motion and at rest. Now you can accelerate compute-intensive operations with Intel<sup>&reg;</sup> QuickAssist Technology (Intel QAT).

This document describes the system setup to use Intel QAT within docker containers.

### Install Driver and Service:

 - Follow the [instructions](https://www.intel.com/content/www/us/en/content-details/710059/intel-quickassist-technology-software-for-linux-getting-started-guide-hw-version-1-7.html) to install the supported OS, kernel, Intel QAT driver and service on the host.


- Enable kernel hugepage support:

```bash
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
sudo systemctl restart qat_service
```

### Configure QATzip and QATengine:

QATzip is a utility (`qzip`) for data compression. QATengine is a crypto engine that can be used in the openssl framework. The async mode NGINX requires both QATzip and QATengine.

While the docker images contain QATzip and QATengine, you **must** configure QATzip and QATengine on each host that the containers run. The QATzip configuration files are located at [QATzip/config_file](https://github.com/intel/QATzip/tree/master/config_file) and the QATengine configuration files are located at [QAT_Engine/qat_hw_config](https://github.com/intel/QAT_Engine/tree/master/qat_hw_config).

There are multiple versions of the configuration files optimized for different adapaters and usage scenarios. Select the ones that meet your adapter and usage pattern. Copy them to the `/etc` directory. Note that QATzip looks for `NumberDcInstances` and QATengine looks for `NumberCyInstances`. Thus you will need to merge the QATzip and QATengine configuration files together as you need both in NGINX.

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


The table lists the available docker images:   
(*media-nginx* image uses QAT HW implementation & *dev/nginx_sw* images use QAT SW implmentation.)
|Image|Dockerfile|Docker Image|
|:-:|---|---|
|media-dev|[ubuntu-22.04/media/dev](ubuntu-22.04/media/dev)<br>[ubuntu-20.04/media/dev](ubuntu-20.04/media/dev)|[openvisualcloud/qat-ubuntu2204-media-dev](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2204-media-dev)<br>[openvisualcloud/qat-ubuntu2004-media-dev](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2004-media-dev)|
|media-nginx|[ubuntu-22.04/media/nginx](ubuntu-22.04/media/nginx)<br>[ubuntu-20.04/media/nginx](ubuntu-20.04/media/nginx)|[openvisualcloud/qat-ubuntu2204-media-nginx](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2204-media-nginx)<br>[openvisualcloud/qat-ubuntu2004-media-nginx](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2004-media-nginx)|
|media-nginx_sw|[ubuntu-22.04/media/nginx_sw](ubuntu-22.04/media/nginx_sw)<br>[ubuntu-20.04/media/nginx_sw](ubuntu-20.04/media/nginx_sw)|[openvisualcloud/qat-ubuntu2204-media-nginx_sw](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2204-media-nginx_sw)<br>[openvisualcloud/qat-ubuntu2004-media-nginx_sw](https://hub.docker.com/r/openvisualcloud/qat-ubuntu2004-media-nginx_sw)|

The docker images **must** run with the following devices attached:  
- `/dev/hugepages`: The hugepage kernel pages.  
- `/dev/uio*`: The uio devices.  
- `/dev/qat_*`: The qat devices.  
- `/dev/usdm_drv`: The usdm device.  

For example, run the following script to start the NGINX Ubuntu image:   

```bash
docker run --cap-add=IPC_LOCK -v /dev/hugepages:/dev/hugepages $(ls -1 /dev/uio* /dev/qat_* /dev/usdm_drv | sed 's/\(.*\)/--device=\1:\1/') -it openvisualcloud/qat-ubuntu2004-media-nginx
```

### Run Docker Images as Non-Root:

To access the mounted [devices](#run-docker-images), the user must have the access permission. The NGINX [sample](ubuntu-20.04/media/nginx/nginx.conf) configuration runs the NGINX instance as root: `user root`. To run NGINX as a non-root user, for example `nobody`, you need to create a `qat` group, the GID of which **must** match that of the `qat` group on the host. Then you can run NGINX as user `nobody` and group `qat`: `user nobody qat`.   

### Known Limitations:   

- The docker images must be built and tested on the host with Intel QAT installed.  

### See Also:

- [Intel QuickAssist Technology](https://01.org/intel-quickassist-technology)   
- [QATzip](https://github.com/intel/QATzip)   
- [QATengine](https://github.com/intel/QAT_Engine)   
- [Async Mode Nginx](https://github.com/intel/asynch_mode_nginx)  


