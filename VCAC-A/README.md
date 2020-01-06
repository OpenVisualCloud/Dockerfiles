
The Intel VCAC-A is designed to accelerate analytics computation. This README describes the steps to setup the Intel VCAC-A and deploy docker images to run on the platform.   

## Setup the VCAC-A:

Please follow the [Software Installation Guide, Section 2.0-Section 2.2.4](https://cdrdv2.intel.com/v1/dl/getContent/611894) to build and configure the software packages for the host and the VCAC-A, with the following additional steps:    

---

To use the VCAC-A as a container platform, we only need to build the **BASIC** system image.       
The following scripts run on the host serving the VCAC-A node.   

---

- **`Setup proxy, datetime, DNS, and passwordless access`** : [setup_access.sh](./script/setup_access.sh)
- **`Install docker-ce on VCAC-A`**: [setup_docker.sh](./script/setup_docker.sh). Alternatively, you can install docker-ee instead on the VCAC-A yourself.
- **`Install hddldaemon on VCAC-A`** : [setup_hddl.sh](./script/setup_hddl.sh). Any inference requests initiated within the docker containers are routed to the HDDL daemon for execution.    

#### See Also:

- The [VCAC-A](https://github.com/OpenVisualCloud/VCAC-SW/tree/VCAC-A) System Software   

## Upload Images onto the VCAC-A:

See each sub-folder for a list of media analytics software stacks targeted for the VCAC-A:    

| Framework | Dockerfile | Docker Image |
|:---------:|:-----------|:-------------|
|   FFMpeg  | [ubuntu-18.04/analytics/ffmpeg/Dockerfile](ubuntu-18.04/analytics/ffmpeg/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-ffmpeg) |
| GStreamer | [ubuntu-18.04/analytics/gst/Dockerfile](ubuntu-18.04/analytics/gst/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1804-analytics-gst`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-analytics-gst) |
|  build | [ubuntu-18.04/dev/Dockerfile](ubuntu-18.04/dev/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1804-dev`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1804-dev) |
|   FFMpeg  | [ubuntu-16.04/analytics/ffmpeg/Dockerfile](ubuntu-16.04/analytics/ffmpeg/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1604-analytics-ffmpeg`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1604-analytics-ffmpeg) |
| GStreamer | [ubuntu-16.04/analytics/gst/Dockerfile](ubuntu-16.04/analytics/gst/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1604-analytics-gst`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1604-analytics-gst) |
|  build | [ubuntu-16.04/dev/Dockerfile](ubuntu-16.04/dev/Dockerfile) | [`openvisualcloud/vcaca-ubuntu1604-dev`](https://hub.docker.com/r/openvisualcloud/xeon-ubuntu1604-dev) |

Use the following command to pull the desired image and then transfer to the VCAC-A:     

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
docker run --rm --user root --privileged -v /var/tmp/hddl_service.sock:/var/tmp/hddl_service.sock -v /var/tmp/hddl_service_ready.mutex:/var/tmp/hddl_service_ready.mutex -v /var/tmp/hddl_service_alive.mutex:/var/tmp/hddl_service_alive.mutex openvisualcloud/vcaca-ubuntu1804-analytics-ffmpeg /bin/bash
```

- **`--user root --privileged`**: The root privilege is required to mount the media and analytics acceleration devices.    
- **`/var/tmp/hddl_service.sock, /var/tmp/hddl_service_ready.mutex` and `/var/tmp/hddl_service_alive.mutex`**: Mount the required auxiliary files for analytics acceleration.           

Optionally, you can also mount:   
- **`-v /etc/localtime:/etc/localtime`**: Synchronize the time zone between the container and the VCAC-A.  
- **`-e http_proxy -e https_proxy -e no_proxy`**: Enable the proxy settings within the container.   

## Setup the VCAC-A as Swarm Node:

You can setup the VCAC-A as a docker swarm worker node. Any subsequent deployment will be as simple as `docker stack deploy`. It is recommended that you setup docker swarm on the host and the VCAC-A as a worker node for application development.       

Run the [setup_swarm.sh](./script/setup_swarm.sh) script on the host to setup docker swarm. The script initializes the host as a swarm master and labels the VCAC-A with `vcac_zone=yes`.   

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

You can setup the VCAC-A as a Kubernetes worker node. Any subsequent deployment will be as simple as `kubectl apply`. It is recommended that you setup the VCAC-A as a Kubernetes worker node for application development.

The VCAC-A node does not have a dedicated IP address accessible from the network. Instead, the VCAC-A node accesses the network via NAT on the host machine. This does not meet the Kubernetes networking requirements, which assume that all workers are accessible via a unique IP address. [WeaveNet](https://github.com/weaveworks/weave) comes to rescue, which supports partially connected mesh network devices. With some `kubectl` workarounds, it's possible to use the VCAC-A as any regular Kubernetes nodes.   

#### Setup Kubernetes:

- Follow the [instructions](https://kubernetes.io/docs/setup) to setup the Kubernetes cluster. You must install [WeaveNet](https://kubernetes.io/docs/concepts/cluster-administration/networking/) as the cluster networking solution.     
- Logon to the VCAC-A host and then the VCAC-A node. Join both the host and the VCAC-A node as worker nodes. 
- Optionally, label the VCAC-A worker as `vcac-zone=yes`: `kubectl label node vcanode0 "vcac-zone=yes"`    

#### Kubectl Workarounds:

The `kubectl logs` and `kubectl exec` commands do not work on the VCAC-A nodes as the nodes are not directly accessible from the Kubernetes master. Instead, use `kubectl vcac logs` and `kubectl vcac exec`. Setup as follows:   
- Copy the [kubectl-vcac-exec](script/kubectl-vcac-exec) and [kubectl-vcac-logs](script/kubectl-vcac-logs) scripts to any of the execution `PATH`, for example, under `~/bin`, on your Kubernetes master. Change permission to make them executable.   
- Create a host file on the Kubernetes master under either `~/.vcac-hosts` or `/etc/vcac-hosts`, which describes the access information. The host file looks like the following:   

```
vcanode0/172.32.1.1 vcac-node-host
vcanode1/172.32.1.2 vcac-node-host
```

where each line describes a VCAC-A node. `vcanode0/172.32.1.1` is the pair of the VCAC-A node name and internal IP address. The pair must be unique. The second field describes the VCAC-A host hostname or `username@hostname`, if the username differs.      

- Setup password-less access from your Kubernetes master to the VCAC-A host(s), and from the VCAC-A host(s) to the VCAC-A node(s), if you haven't done so, as follows:   

```sh
ssh-keygen
ssh-copy-id <username>@<hostname>
```

Now you can use `kubectl vcac logs` or `kubectl vcac exec` to retrieve logs and execute remote commands:  

```sh
kubectl vcac logs -f <pod-id>
kubectl vcac exec <pod-id> /bin/bash
```

#### Develop Deployment Script:

The VCAC-A deployment script looks like the following (from the [Smart City](https://github.com/OpenVisualCloud/Smart-City-Sample) sample):

```
...
      containers:
        - name: traffic-office1-analytics
          image: smtc_analytics_object_detection_vcac-a_gst:latest
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: /var/tmp/hddl_service.sock
              name: var-tmp-hddl-service-sock
            - mountPath: /var/tmp/hddl_service_ready.mutex
              name: var-tmp-hddl-service-ready-mutex
            - mountPath: /var/tmp/hddl_service_alive.mutex
              name: var-tmp-hddl-service-alive-mutex
          securityContext:
            privileged: true
      volumes:
          - name: var-tmp-hddl-service-sock
            hostPath:
              path: /var/tmp/hddl_service.sock
              type: Socket
          - name: var-tmp-hddl-service-ready-mutex
            hostPath:
              path: /var/tmp/hddl_service_ready.mutex
              type: File
          - name: var-tmp-hddl-service-alive-mutex
            hostPath:
              path: /var/tmp/hddl_service_alive.mutex
              type: File
      nodeSelector:
          vcac-zone: "yes"
...
```

where you must:

- Mount the auxiliary files: `/var/tmp/hddl_service.sock`, `/var/tmp/hddl_service_ready.mutex`, and `/var/tmp/hddl_service_alive.mutex`.   
- Set the `securityContext` to be `priviledged`. This will mount the devices for media and analytics acceleration.   
- Select the VCAC-A node by label `vcac-zone=yes`.   

#### See Also:

- [AD Insertion Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Ad-Insertion-Sample/blob/master/doc/vcac-a.md)
- [Smart City Sample VCAC-A Setup](https://github.com/OpenVisualCloud/Smart-City-Sample/blob/master/doc/vcac-a.md)
