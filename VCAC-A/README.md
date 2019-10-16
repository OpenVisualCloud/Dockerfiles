This folder contains docker files to build software stack for Intel(R) VCAC-A cards.


## 1. Setup VCAC-A:

VCAC-A Software Setup and Boot up. Please follow the [Software Installation Guide](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build the package for Host and VCAC-A and boot up the VCAC-A. See details in Section 2 in the [Software Installation Guide](https://cdrdv2.intel.com/v1/dl/getContent/611894).

## Additional steps to following:

## Step 1.1: Install Docker on Host and VCAC-A card

See the detail in section 2.1.2 of [Software Installation Guide](https://cdrdv2.intel.com/v1/dl/getContent/611894)

## Step 1.2: Install OpenVINO on VCAC-A

After the VCAC-A card is boot up, login to VCAC-A card through ssh, and install the OpenVINO software.
Here is the [Link](https://software.intel.com/en-us/openvino-toolkit/choose-download) to download. The package name: l_openvino_toolkit_p_201x.x.xxx.tgz:

See detail steps in the [Guide](https://docs.openvinotoolkit.org/latest/_docs_install_guides_installing_openvino_linux.html).

Here are simple steps:

	tar xvf l_openvino_toolkit_p_201x.x.xxx.tgz
	cd l_openvino_toolkit_p_201x.x.xxx
	./install.sh

The required component:

	Inference Engine
	Model Optimizer

#### Note: The same version of OpenVINO is installed in VCAC-A vcad image and docker image.

## Step 1.3: Check the HDDL daemon on VCAC-A

run the following cmd:

        Source /opt/intel/openvino/bin/SetupEnv.sh
        /opt/intel/openvino/inference_engine/external/hddl/bin/hddldaemon


## 2. Upload and load docker image on VCAC-A

## Step 2.1: Pull the base docker image for analytic

Image name:
+       openvisualcloud/vcaca-ubuntu1604-analytics-ffmpeg
+       openvisualcloud/vcaca-ubuntu1604-analytics-gst



	docker pull image:tag


## Step 2.2: Load docker image on VCAC-A

Sample Command to transfer and load the image to VCAC-A:

Command for FFMPEG:

	docker save vcaca_analytics_ffmpeg_ubuntu1604:latest | ssh root@xxx.xxx.xxx.xxx "docker image rm -f vcaca_analytics_ffmpeg_ubuntu1604:latest 2>/dev/null; docker load"

Command for GST:

	docker save vcaca_analytics_gst_ubuntu1604:latest | ssh root@xxx.xxx.xxx.xxx "docker image rm -f vcaca_analytics_gst_ubuntu1604:latest 2>/dev/null; docker load"

See [sample script](./script/sample_upload_single_image.sh).		

## Step 2.3: Verify image loaded via docker images command on VCAC-A:


	docker images

Run the above command and see the similar as the following:


	REPOSITORY                                           TAG                 IMAGE ID            CREATED             SIZE
	openvisualcloud/vcaca-ubuntu1804-analytics-gst       19.10               f25dbdc9e3fc        8 days ago          1.03GB
	openvisualcloud/vcaca-ubuntu1804-analytics-gst       latest              f25dbdc9e3fc        8 days ago          1.03GB
	openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg    19.10               11201fece958        8 days ago          199MB
	openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg    latest              11201fece958        8 days ago          199MB



##  3. Command options to run the docker on the VCAC-A

This section helps understand the basic docker options when create the container for this image.

When the docker image is loaded on the VCAC-A card, please creat the docker container with the following options accordingly.

Enable the following options via "docker run" command.

## Set the user to run the docker

	 --user root

## Enable --privileged

	The --privileged allow to see the device on the Host in the docker. here is /dev/ion

## Enable GUI if needed

	-v ~/.Xauthority:/root/.Xauthority
	-v /tmp/.X11-unix/:/tmp/.X11-unix
	-e DISPLAY=$DISPLAY

## Set the proxy

	-e HTTP_PROXY=$HTTP_PROXY
	-e HTTPS_PROXY=$HTTPS_PROXY
	-e http_proxy=$http_proxy
	-e https_proxy=$https_proxy

## Mount the /tmp folder

	-v /tmp:/tmp
	-v /var/tmp:/var/tmp

## Mount the /dev folder

        -v /dev:/dev

or mount the device directly 

	--device=/dev/ion:/dev/ion

## Mount the user folder

The user's data, such as video clip, model etc. , can be be shared by this folder.

here is Sample:

	-v /mnt/share:/mnt/share

## To sync the host time and local time in the docker container

	-v /etc/localtime:/etc/localtime:ro

## 4. Tutorial: Run docker in standalone mode.

If you try to explore the docker, it is easy to run with the following script and try FFMPEG/GST in it.

See [sample script](./script/sample_run_vcac-a_docker.sh) and try to run the docker in standalone mode.


## Run FFMPEG and GST command in the standalone mode

+	See [sample command for FFMPEG](../doc/ffmpeg.md)
+	See [sample command for GST](../doc/gst.md)

## 5. Tutorial:Deploy the docker in swarm mode

This helps understand how to deploy the docker in your application. It supports to deploy on the multi nodes.

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


