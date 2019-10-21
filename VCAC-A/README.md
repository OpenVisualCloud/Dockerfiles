
Intel VCAC-A is designed to accelerate analytics computation. This README describes the steps to setup Intel VCAC-A and deploy docker images to run on the platform.   

## 1. Setup VCAC-A:

Please follow the [Software Installation Guide, Section 2](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build and configure the software packages for the host and the VCAC-A, with the following additional steps:    

### Step 1.1: Install Docker Engine on Host and VCAC-A

Follow the [instructions](https://docs.docker.com/v17.09/engine/installation) to install the latest docker engine on both the host and the VCAC-A. It is important that you properly setup proxies if you are behind a corporation firewall.    

### Step 1.2: Install Intel OpenVINO on VCAC-A

Login to VCAC-A and install the Intel OpenVINO software by downloading from this [link](https://software.intel.com/en-us/openvino-toolkit/choose-download). The package name should read ```l_openvino_toolkit_p_201x.x.xxx.tgz```. 

The only required component is as follows:
- Inference Engine

After installation, start the HDDL daemon as follows. 

```
Source /opt/intel/openvino/bin/SetupEnv.sh
/opt/intel/openvino/inference_engine/external/hddl/bin/hddldaemon
```

It is critical that the HDDL daemon is running always. Any inference requests initiated within the docker containers are routed to the HDDL daemon for execution.    

## 2. Upload Docker Images onto VCAC-A

See each sub-folder for a list of docker images designed for VCAC-A, for example, ```openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg```. Use the following command (or the utility script [sample_upload_single_image.sh](script/sample_upload_single_image.sh)) to transfer the specified docker image from the host to VCAC-A:     

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

### See Also

- The utility script [sample-run_vcac-a_docker.sh](script/sample_run_vcac-a_docker.sh) 
- [FFmpeg Docker Images Documentation](../doc/ffmpeg.md)
- [GStreamer Docker Images Documentation](../doc/gst.md)

## 4. Setup VCAC-A as a Docker-Swarm Worker

As Docker-Compose file format version 3 does not support device mount. We need to use the [docker-in-docker](https://hub.docker.com/_/docker) workaround (to be able to mount the media and acceleration devices.) The workaround let the docker compose file launches a docker container as root, mount the devices, and then the docker container subsequently launches the application container.   

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
where ```vcac-container-launcher``` is 

## Enable attachable network

Now it require the attahable network in swarm mode.Sample to create an attachable network in yaml file:

	networks:
	    default_net:
        	driver: overlay
        	attachable: true


## Setup VCAC-A passwordless access

Generate the public and private key on the host if not generated:

	cat /dev/zero | ssh-keygen -q -N ""
	echo

Copy the public key to VCAC-A:

	ssh-copy-id root@xxx.xxx.xxx.xxx 2> /dev/null || echo

## Add the VCAC-A as the swarm node.

Setup host docker swarm if not already,run command on Host:

	docker swarm leave --force 2> /dev/null
	docker swarm init --advertise-addr=172.32.1.254 2> /dev/null || echo

Add the VCAC-A into the swarm if not already, run command on VCAC-A:

	docker swarm join --token xxxxx 172.32.1.254:2377

See the [Sample Script](./script/sample_swarm_setup_vcac-a.sh) to setup the VCAC-A as the swarm node.

## Upload the docker image to VCAC-A

See the [Sample Script](./script/sample_swarm_upload_image.sh) to upload the image on the VCAC-A node.

## Start the docker in the docker container

#### Build the docker from docker:stable, here is the sample script:

	# vcac-container-launcher

	FROM docker:stable
	COPY platforms/VCAC-A/run-container.sh /usr/local/bin
	ENTRYPOINT ["/usr/local/bin/run-container.sh"]


#### Run the docker in the container:

See the [Sample script](./script/sample_run_container.sh)

#### Sample in the yaml file

Take the following as the [example](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/deployment/docker-swarm/analytics.VCAC-A.m4) to define your service accordingly:

Sample:

          XXXX _analytics:
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


