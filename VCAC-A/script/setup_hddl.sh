#!/bin/bash

DIR="/opt/intel/openvino/hddl"
docker_build_dir="${DIR}/ubuntu-openvino-hddl"
docker_compose_dir="${DIR}/ov_hddl"
openvino_name="l_openvino_toolkit_p_2019.3.334"
ov_link="http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/$openvino_name.tgz"
ov_hddl="ov_hddl"
ov_hddl_version="v1"

build_hddl_container()
{
	mkdir -p "$docker_build_dir"
        dockerfile="${docker_build_dir}/Dockerfile"
	entryfile="${docker_build_dir}/run_hddl.sh"
	gen_Dockerfile "$dockerfile"
	gen_entryfile "$entryfile"
	docker build -t ${ov_hddl}:${ov_hddl_version} $(env | grep -E '(proxy|PROXY)=' | sed 's/^/--build-arg /') "${docker_build_dir}/"
}

#docker compose will keep container up even cross node reboot
install_hddl_compose()
{
	curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
	chmod +x /usr/bin/docker-compose
	mkdir -p "$docker_compose_dir"
	composefile="${docker_compose_dir}/docker-compose.yml"
	gen_Dockercomposefile "$composefile"
	cd "$docker_compose_dir"
	docker-compose up -d ov_hddl_run
}

gen_Dockerfile()
{
    cat > "$1" <<EOF
FROM ubuntu:18.04 as builder
ARG DOWNLOAD_LINK=https://github.com/libusb/libusb/archive/v1.0.22.tar.gz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer
ADD $ov_link \$TEMP_DIR/openvino.tgz
ADD \$DOWNLOAD_LINK \$TEMP_DIR/libusb.tar.gz
RUN apt-get update && apt-get install -y --no-install-recommends \\
    cpio sudo python3-pip python3-setuptools \\
    libboost-filesystem1.65 libboost-thread1.65 libboost-program-options1.65 \\
    libjson-c-dev build-essential autoconf automake libtool \\
    kmod libelf-dev libusb-1.0-0 lsb-release && \\
    rm -rf /var/lib/apt/lists/*
RUN cd \$TEMP_DIR && \\
    tar xf openvino.tgz && \\
    cd l_openvino_toolkit* && \\
    sed -i 's/decline/accept/g' silent.cfg && \\
    ./install.sh -s silent.cfg
RUN cd \$TEMP_DIR && \\
    tar xvf libusb.tar.gz && \\
    cd libusb-1.0.22/ && \\
    ./autogen.sh enable_udev=no && \\
    make -j \$(nproc) && \\
    cp ./libusb/.libs/libusb-1.0.so /lib/x86_64-linux-gnu/libusb-1.0.so.0
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \\
    python3 deployment_manager.py --targets=hddl --output_dir=/root --archive_name=hddl

FROM ubuntu:18.04
RUN apt-get update && apt-get install -y sudo libboost-filesystem1.65 nasm \\
    libboost-thread1.65 libboost-program-options1.65 libboost-all-dev libjson-c-dev libusb-1.0-0 \\
    autoconf automake libtool kmod libelf-dev lsb-release && \\
    apt-get clean && \\
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /lib/x86_64-linux-gnu/libusb-1.0.so.0 /lib/x86_64-linux-gnu/libusb-1.0.so.0
RUN mkdir -p /opt/intel
COPY --from=builder /root/hddl.tar.gz /opt/intel
RUN cd /opt/intel && tar xvf hddl.tar.gz && rm hddl.tar.gz
COPY run_hddl.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/run_hddl.sh"]
EOF
}

gen_entryfile()
{
	cat > "$1" <<EOF
#!/bin/bash

if [ "\$1" == "init" ]; then
        modprobe i2c-dev i2c-i801 i2c-hid
        cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/drivers
        bash setup.sh install
	while true; do sleep 3600; done
else
        while [ ! -c /dev/ion ] ; do sleep 1; done
        source /opt/intel/openvino/bin/setupvars.sh
        cd /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin
        while true; do ./hddldaemon; sleep 1; done
fi
EOF
	chmod +x "$1"
}

gen_Dockercomposefile()
{
	cat > "$1" <<EOF
version: '3.7'
services:
  ov_hddl_init:
      image: ov_hddl:v1
      command: init
      container_name: ov_hddl_init
      volumes:
        - /usr/src:/usr/src
        - /lib/modules:/lib/modules
      restart: unless-stopped
      privileged: true
  ov_hddl_run:
      image: ov_hddl:v1
      depends_on:
        - ov_hddl_init
      container_name: ov_hddl_run
      volumes:
        - /dev:/dev
        - /var/tmp:/var/tmp
      restart: unless-stopped
      privileged: true
EOF
}

case "$0" in
    *install*)
        build_hddl_container
        install_hddl_compose
        ;;
    *setup*)
        NODEUSER="root"
        for nodeip in $(sudo vcactl network ip 2>/dev/null | grep -E '^[0-9.]+$'); do
            echo "setup on $nodeip" $0
            scp "$0" $NODEUSER@$nodeip:/root/install-hddl.sh
	    # install package on VCAC-A
            ssh $NODEUSER@$nodeip /root/install-hddl.sh
        done
        ;;
esac
