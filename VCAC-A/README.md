
The Intel VCAC-A is designed to accelerate analytics computation. This README describes the steps to setup the Intel VCAC-A and deploy docker images to run on the platform.   

## Setup the VCAC-A:

Please follow the [Software Installation Guide, Section 2.0-Section 2.2.4](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build and configure the software packages for the host and the VCAC-A, with the following additional steps:    

> To use the VCAC-A as a container platform, we only need to build the **BASIC** system image.       
> The following scripts run on the host serving the VCAC-A node.   

- **`Setup proxy, datetime, DNS, and passwordless access`** : [setup_access.sh](./script/setup_access.sh)
- **`Install docker-ce on VCAC-A`**: [setup_docker.sh](./script/setup_docker.sh). Alternatively, you can install docker-ee instead on the VCAC-A yourself.
- **`Install hddldaemon on VCAC-A`** : [setup_hddl.sh](./script/setup_hddl.sh). Any inference requests initiated within the docker containers are routed to the HDDL daemon for execution.  

> By default, the [setup_hddl.sh](./script/setup_hddl.sh) script installs the latest HDDL daemon image. You can specify the tag of the HDDL daemon image as an input parameter.   
> If you setup VCAC-A for Kubernetes only, you can deploy the daemonSet script, [`setup_hddl_daemonset.yaml`](script/setup_hddl_daemonset.yaml) instead, as follows: `kubectl apply -f setup_hddl_daemonset.yaml`. By default, the script deploys the latest HDDL daemon image. Modify the script if you need to use a specific HDDL daemon image.   

#### See Also:

- The [VCAC-A](https://github.com/OpenVisualCloud/VCAC-SW-Analytics) System Software   

## Upload Images onto the VCAC-A:

The following table shows a list of docker images targeted for the VCAC-A:    

|Image|Dockerfile|Docker Image|
|:-:|---|---|
|analytics-dev|[ubuntu-18.04/analytics/dev](ubuntu-18.04/analytics/dev)<br>[ubuntu-20.04/analytics/dev](ubuntu-20.04/analytics/dev)|[openvisualcloud/vcaca-ubuntu1804-analytics-dev](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu1804-analytics-dev)<br>[openvisualcloud/vcaca-ubuntu2004-analytics-dev](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu2004-analytics-dev)|
|analytics-ffmpeg|[ubuntu-18.04/analytics/ffmpeg](ubuntu-18.04/analytics/ffmpeg)<br>[ubuntu-20.04/analytics/ffmpeg](ubuntu-20.04/analytics/ffmpeg)|[openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg)<br>[openvisualcloud/vcaca-ubuntu2004-analytics-ffmpeg](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu2004-analytics-ffmpeg)|
|analytics-gst|[ubuntu-18.04/analytics/gst](ubuntu-18.04/analytics/gst)<br>[ubuntu-20.04/analytics/gst](ubuntu-20.04/analytics/gst)|[openvisualcloud/vcaca-ubuntu1804-analytics-gst](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu1804-analytics-gst)<br>[openvisualcloud/vcaca-ubuntu2004-analytics-gst](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu2004-analytics-gst)|
|analytics-hddldaemon|[ubuntu-18.04/analytics/hddldaemon](ubuntu-18.04/analytics/hddldaemon)|[openvisualcloud/vcaca-ubuntu1804-analytics-hddldaemon](https://hub.docker.com/r/openvisualcloud/vcaca-ubuntu1804-analytics-hddldaemon)|

Use the following command to transfer any desired image to the VCAC-A:     

```
docker pull openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg
docker save openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg | ssh root@172.32.xxx.xxx "docker load"
```

#### See Also:

- [Dockerfiles and Images](../README.md)   
- [FFmpeg Docker Images Documentation](../doc/ffmpeg.md)
- [GStreamer Docker Images Documentation](../doc/gst.md)

## Run Containers on the VCAC-A:

The following `docker run` command line options are **required** to run docker containers on the VCAC-A:   

```
# Running openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg
docker run --rm --user root --privileged -v /var/tmp:/var/tmp openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg /bin/bash
```

- **`--user root --privileged`**: The root privilege is required to mount the media and analytics acceleration devices.    
- **`/var/tmp`**: Mount the required directory for analytics acceleration.           

Optionally, you can also mount:   
- **`-v /etc/localtime:/etc/localtime`**: Synchronize the time zone between the container and the VCAC-A.  
- **`-e http_proxy -e https_proxy -e no_proxy`**: Enable the proxy settings within the container.   

## Setup the VCAC-A as Swarm Node:

You can setup the VCAC-A as a docker swarm worker node. Any subsequent deployment will be as simple as `docker stack deploy`. It is recommended that you setup docker swarm on the host and the VCAC-A as a worker node for local application development.       

Run the [setup_swarm.sh](./script/setup_swarm.sh) script on the host to setup docker swarm. The script initializes the host as a swarm master and labels the VCAC-A with `vcac_zone=yes`.   

> The Docker Swarm mode is limited to a single VCAC-A on a host system, (because `docker swarm init` must bind to a specific network interface,) unless you use the [WeaveNet](#setup-weavenet) workaround. In such a case, initialize docker swarm with `./setup_swarm.sh $(/usr/local/bin/weave expose)`.   

#### Develop Docker-Compose Script:

Docker Compose File Format version 3 does not support device mount. We need to use the [docker-in-docker](https://hub.docker.com/_/docker) workaround (to be able to mount the media and analytics devices.) The workaround launches a privileged docker container that subsequently runs the application container. The [`vcac-container-launcher:latest`](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/analytics/common/VCAC-A/Dockerfile.1.launcher) Dockerfile builds to an enhanced dock-in-docker image that additionally passes on environment variables, mounts network and volumes, and gracefully shutdown.   

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

- The `VCAC_IMAGE` variable specifies the application image.  
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
- [AD Insertion Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Ad-Insertion-Sample/blob/master/doc/vcac-a.md)
- [Smart City Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/doc/vcac-a.md)

## Setup the VCAC-A as Kubernetes Node:

You can setup the VCAC-A as a Kubernetes worker node. Any subsequent deployment will be as simple as `kubectl apply`. It is recommended that you setup the VCAC-A as a Kubernetes worker node for application development and deployment.  

The VCAC-A node does not have a dedicated IP address accessible from the network. Instead, the VCAC-A node accesses the network via NAT on the host machine. Strictly speaking, this does not meet the Kubernetes networking requirement, which states that all worker nodes are accessible via a unique IP address. [WeaveNet](https://github.com/weaveworks/weave) comes to rescue, which supports partially connected network devices. The following sections describe the steps to setup the Weave virtual network and then install Kubernetes on top of the WeaveNet.    

#### Setup WeaveNet:

First designate certain IP network range for the WeaveNet virtual network. The default is `172.30.0.0/16`. Modify `/etc/environment` to add this network range into your `no_proxy` environment variable, if you are behind a corporate firewall.     

Run the [`setup_weave.sh`](script/setup_weave.sh) script, as `./setup_weave.sh <cluster-master-node-host-name> [virtual-network-IP-range]`, on every cluster node, starting with the cluster master node and then on each cluster worker node. The script performs the following tasks:      
- Download the WeaveNet software under `/usr/local/bin`.       
- Start a `weave.service` that connects your node to the cluster master node.   
- Configure `kubelet` of your node IP address.   
- Show the WeaveNet IP address.     

---

For VCAC-A, run the [`setup_weave.sh`](script/setup_weave.sh) script on both the VCAC-A host and each VCAC-A node.    

---

#### Setup Kubernetes:

- Follow the [instructions](https://kubernetes.io/docs/setup) to setup the Kubernetes cluster, with the following additions during the master-node setup:   
  - Add `--apiserver-advertise-address=$(/usr/local/bin/weave expose)` to your `kudeadm init` command. `$(/usr/local/bin/weave expose)` retrieves the WeaveNet IP address of the master-node.          
  - You can install any Layer-3 (IP-based) [POD network plugin](https://kubernetes.io/docs/concepts/cluster-administration/networking). For example, [flannel](https://github.com/coreos/flannel) is a good place to start.      

- Join the Kubernetes worker nodes to the cluster. For VCAC-A, join both the VCAC-A host and each VCAC-A node to the Kubernetes cluster.    
- Add a node label to each VCAC-A worker node for POD scheduling as follows:    

```bash
kubectl label node <node-name> vcac-zone=yes
```

- Optionally, for non-priliveged containers (as in production), it is recommended to install the Intel [GPU](https://github.com/intel/intel-device-plugins-for-kubernetes/blob/master/cmd/gpu_plugin/README.md) and [VPU](https://github.com/intel/intel-device-plugins-for-kubernetes/blob/master/cmd/vpu_plugin/README.md) device plugins. The GPU device plugin is for enabling media acceleration and the VPU device plugin is for enabling analytics acceleration.    

#### Develop Deployment Script:

The VCAC-A deployment script looks like the following (from the [Smart City](https://github.com/OpenVisualCloud/Smart-City-Sample) sample):

**Run Containers as Privileged** (for development):  

```
...
      containers:
        - name: traffic-office1-analytics
          image: smtc_analytics_object_detection_vcac-a_gst:latest
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: /var/tmp
              name: var-tmp
          securityContext:
            privileged: true
      volumes:
          - name: var-tmp
            hostPath:
              path: /var/tmp
              type: Directory
      nodeSelector:
          vcac-zone: "yes"
...
```

where you must:

- Mount the `/var/tmp` directory.   
- Set the `securityContext` to be `priviledged`. This will mount the devices for media and analytics acceleration.   
- Select the VCAC-A node(s) by the `vcac-zone=yes` label.      

**Run Containers as Non-Privileged** (GPU and VPU device plugins required to be installed): 

```
...
      containers:
        - name: traffic-office1-analytics
          image: smtc_analytics_object_detection_vcac-a_gst:latest
          imagePullPolicy: IfNotPresent
          resources:
            limits:
              vpu.intel.com/hddl: 1
              gpu.intel.com/i915: 1
      nodeSelector:
          vcac-zone: "yes"
...
```

#### See Also:   
- [WeaveNet Installation](https://www.weave.works/docs/net/latest/install)   
- [AD Insertion Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Ad-Insertion-Sample/blob/master/doc/vcac-a.md)
- [Smart City Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/doc/vcac-a.md)
- [Intel Device Plugins for Kubernetes](https://github.com/intel/intel-device-plugins-for-kubernetes)   
