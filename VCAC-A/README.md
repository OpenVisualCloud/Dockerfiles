
Intel VCAC-A is designed to accelerate analytics computation. This README describes the steps to setup Intel VCAC-A and deploy docker images to run on the platform.   

## 1. Setup VCAC-A:

Please follow the [Software Installation Guide, Section 2.0-Section 2.2.4](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build and configure the software packages for the host and the VCAC-A, with the following additional steps:    

- **Install Docker Engine on Host and VCAC-A**

Follow the [instructions](https://docs.docker.com/v17.09/engine/installation) to install the latest docker engine on both the host and the VCAC-A. It is important that you properly setup proxies if you are behind a corporation firewall.

Here are the scripts to install Docker on the VCAC-A:
-  **```Setup Passwordless access```** : [setup_access.sh](./script/setup_access.sh)
-  **```Install docker-ce on VCAC-A```**: [setup_docker.sh](./script/setup_docker.sh). Alternatively, you can install docker-ee instead on the VCAC-A yourself.
-  **```Install OpenVINO and start hddldaemon on VCAC-A```** : [setup_hddl.sh](./script/setup_hddl.sh)

It is critical that the HDDL daemon is running always. Any inference requests initiated within the docker containers are routed to the HDDL daemon for execution.    

## 2. Upload Docker Images onto VCAC-A

See each sub-folder for a list of docker images designed for VCAC-A, for example, ```openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg```. Use the following command (or the utility script [upload_image1.sh](script/upload_image1.sh)) to transfer the specified docker image from the host to VCAC-A:     

```
docker save <image-name>  | ssh root@172.32.xxx.xxx "docker image rm -f <image-name> 2>/dev/null; docker load"
```

##  3. Run Docker Containers on VCAC-A

The following ```docker run``` commandline options are **required** to run docker containers on VCAC-A:   
- **```--user root --privileged```**: Root privilege is required to mount the media and analytics acceleration devices.    
- **```-v /dev:/dev```**: Mount the media and analytics acceleration devices. Specifically, ```/dev/card???``` is for media decoding acceleration and ```/dev/ion``` is for analytics acceleration.       
- **```-v /tmp:/tmp -v /var/tmp:/var/tmp```**: Mount the directory for analytics data transfering.    
- **```-v ~/.Xauthority:/root/.Xauthority -v /tmp/.X11-unix/:/tmp/.X11-unix -e DISPLAY=$DISPLAY```**: The ```XHost``` authority is required for media decoding acceleration. 

Optionally, you can also mount:   
- **```-v /etc/timezone:/etc/timezone```**: Synchronize the time zone between the container and the VCAC-A.  
- **```-e http_proxy -e https_proxy -e no_proxy```**: Enable proxy settings within the container.   

#### See Also

- The utility script [docker_run.sh](script/docker_run.sh) 
- [FFmpeg Docker Images Documentation](../doc/ffmpeg.md)
- [GStreamer Docker Images Documentation](../doc/gst.md)

## 4. Setup VCAC-A as a Docker-Swarm Worker

You can setup VCAC-A as a docker swarm worker node. Then any subsequent deployment will be as simple as ```docker stack deploy```. It is recommended that you setup docker swarm on the host and VCAC-A as a worker node for application development.       

- **Add the VCAC-A as the swarm node**

Setup host docker swarm if not already,run the following commands (or the utility script [setup_swarm.sh](./script/setup_swarm.sh)):  

```
docker swarm leave --force 2> /dev/null
docker swarm init --advertise-addr=172.32.1.254 2> /dev/null
ssh 172.32.xx.xx "docker swarm join --token xxxxx 172.32.1.254:2377"
```

- **Develop Docker Compose File**

As Docker Compose File Format version 3 does not support device mount. We need to use the [docker-in-docker](https://hub.docker.com/_/docker) workaround (to be able to mount the media and acceleration devices.) The workaround let the docker compose file launches a docker container as root, mount the devices, and then the docker container subsequently launches the application container.   

The following docker compose file from the [Smart-City-Sample](https://github.com/OpenVisualCloud/Smart-City-Sample) project illustrates the concept:  

```
...
          traffic_office1_analytics:
                image: vcac-container-launcher:latest
                command: ["--volume","traffic_office1_andata:/home/video-analytics/app/server/recordings:rw","--network","smtc_default_net","smtc_analytics_object_detection_vcac-a_gst:latest"]
                volumes:
                    - /var/run/docker.sock:/var/run/docker.sock
                    - traffic_office1_andata:/home/video-analytics/app/server/recordings:rw
                    - /etc/localtime:/etc/localtime:ro
                environment:
                    VCAC_OFFICE: "45.539626,-122.929569"
                    VCAC_DBHOST: "http://db:9200"
                    VCAC_MQTTHOST: "traffic_office1_mqtt"
                    VCAC_EVERY_NTH_FRAME: 6
                    VCAC_STHOST: "http://traffic_office1_storage:8080/api/upload"
                    VCAC_NO_PROXY: "*"
                    VCAC_no_proxy: "*"
                networks:
                    - default_net
                deploy:
                    replicas: 3
                    placement:
                        constraints:
                            - node.labels.vcac_zone==yes
...
```
where [```vcac-container-launcher```](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/analytics/common/platforms/VCAC-A/Dockerfile.5.launcher.vcac-a) is a modified variation of the docker image, adding logic to pass on environment variables (to the application container) and intercept the SIGTERM signal for gracefully shutdown.  

```
# vcac-container-launcher
FROM docker:stable
COPY platforms/VCAC-A/run-container.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/run-container.sh"]
```

When running the docker-in-docker workaround, the application container does not directly run within the default docker network. Thus the application must setup its own network and make it attachable, as follows:   
```
	networks:
	    default_net:
        	driver: overlay
        	attachable: true
```

- **Upload the image to VCAC-A**

here is the utility script to upload the image onto all the VCAC-A cards: [upload_images.sh](./script/upload_images.sh).

```
upload_images.sh xxxx.tar
```

## See Also

- [AD Insertion Sample](https://github.com/OpenVisualCloud/Ad-Insertion-Sample)
- [Smart City Sample](https://github.com/OpenVisualCloud/Smart-City-Sample)
