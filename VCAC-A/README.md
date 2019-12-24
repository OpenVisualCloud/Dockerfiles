
The Intel VCAC-A is designed to accelerate analytics computation. This README describes the steps to setup the Intel VCAC-A and deploy docker images to run on the platform.   

## Setup the VCAC-A:

Please follow the [Software Installation Guide, Section 2.0-Section 2.2.4](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build and configure the software packages for the host and the VCAC-A, with the following additional steps:    

---

To use the VCAC-A as a container platform, we only need to build the **BASIC** system image.    

---

- **`Setup passwordless access`** : [setup_access.sh](./script/setup_access.sh)
- **`Install docker-ce on VCAC-A`**: [setup_docker.sh](./script/setup_docker.sh). Alternatively, you can install docker-ee instead on the VCAC-A yourself.
- **`Install hddldaemon on VCAC-A`** : [setup_hddl.sh](./script/setup_hddl.sh). Any inference requests initiated within the docker containers are routed to the HDDL daemon for execution.    

#### See Also:

- [VCAC-A System Software](https://github.com/OpenVisualCloud/VCAC-SW/tree/VCAC-A)   

## Upload Images onto the VCAC-A:

See each sub-folder for a list of docker images targeted for the VCAC-A, for example, `openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg`. Use the following command to transfer the image from the host to the VCAC-A:     

```
docker pull openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg
docker save <image-name>  | ssh root@172.32.xxx.xxx "docker image rm -f <image-name> 2>/dev/null; docker load"
```

## Run Containers on the VCAC-A:

The following `docker run` command line options are **required** to run docker containers on the VCAC-A:   
- **`--user root --privileged`**: Root privilege is required to mount the media and analytics acceleration devices.    
- **`-v /dev:/dev`**: Mount the media and analytics acceleration devices, specifically, `/dev/card???` for media acceleration and `/dev/ion` for analytics acceleration.       
- **`-v /tmp:/tmp -v /var/tmp:/var/tmp`**: Mount the directory for analytics data transfering.    
- **`-v ~/.Xauthority:/root/.Xauthority -v /tmp/.X11-unix/:/tmp/.X11-unix -e DISPLAY=$DISPLAY`**: The `XHost` authority is required for media decoding acceleration. 

Optionally, you can also mount:   
- **`-v /etc/localtime:/etc/localtime`**: Synchronize the time zone between the container and the VCAC-A.  
- **`-e http_proxy -e https_proxy -e no_proxy`**: Enable the proxy settings within the container.   

```
docker run --rm --user root -v /tmp:/tmp -v /var/tmp:/var/tmp --device=/dev/ion:/dev/ion --privileged openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg /bin/bash
```

#### See Also:

- [FFmpeg Docker Images Documentation](../doc/ffmpeg.md)
- [GStreamer Docker Images Documentation](../doc/gst.md)

## Setup the VCAC-A as Swarm Node:

You can setup the VCAC-A as a docker swarm worker node. Any subsequent deployment will be as simple as `docker stack deploy`. It is recommended that you setup docker swarm on the host and the VCAC-A as a worker node for application development.       

Run the [setup_swarm.sh](./script/setup_swarm.sh) script on the host to setup docker swarm if not already. The host is initialized as a swarm master.   

## Develop Deployment Script:

Docker Compose File Format version 3 does not support device mount. We need to use the [docker-in-docker](https://hub.docker.com/_/docker) workaround (to be able to mount the media and analytics devices.) The workaround launches a previleged docker container that subsequently runs the application container.   

The following docker compose file from the [Smart-City-Sample](https://github.com/OpenVisualCloud/Smart-City-Sample) project illustrates the concept:  

```
...
        traffic_office1_analytics:
            image: vcac-container-launcher:latest
            environment:
                VCAC_IMAGE: smtc_analytics_object_detection_vcac-a_gst:latest
                VCAC_OFFICE: "45.539626,-122.929569"
                VCAC_DBHOST: "http://db:9200"
                VCAC_MQTTHOST: "traffic_office1_mqtt"
                VCAC_EVERY_NTH_FRAME: 6
                VCAC_STHOST: "http://traffic_office1_storage:8080/api/upload"
                VCAC_NO_PROXY: "*"
                VCAC_no_proxy: "*"
            volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - /etc/localtime:/etc/localtime:ro
            networks:
                - appnet
            deploy:
                replicas: 3
                placement:
                    constraints:
                        - node.labels.vcac_zone==yes
...
```

where   

- The `VCAC_IMAGE` variable specifies the application image, the [`vcac-container-launcher:latest`](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/analytics/common/VCAC-A/Dockerfile.1.launcher) is a modified image with enhancement to pass on environment variables, mount network and volumes, and gracefully shutdown.   
- The `VCAC_` prefixed variables are to be passed onto the application container.   
- The `/var/run/docker.sock` volume mount is **required** to enable docker-in-docker.   
- When running the docker-in-docker workaround, the application container does not directly run within the default docker network. The application must setup its own network and make it attachable, as follows:   

```
        networks:
	    appnet:
        	driver: overlay
        	attachable: true
```

#### See Also:

- [Container Launcher Dockerfile](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/analytics/common/VCAC-A/Dockerfile.1.launcher)   
- [AD Insertion Sample](https://github.com/OpenVisualCloud/Ad-Insertion-Sample)
- [Smart City Sample](https://github.com/OpenVisualCloud/Smart-City-Sample)

