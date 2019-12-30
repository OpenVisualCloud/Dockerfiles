#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))
openvino_name="l_openvino_toolkit_p_2019.3.334"
ov_link="http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/$openvino_name.tgz"
py_ver='3.7.2'
py_link="https://www.python.org/ftp/python/$py_ver/Python-$py_ver.tgz"
package_name="intel-vcaa-hddl"
ov_hddl="ov_hddl"
ov_hddl_version="v1"
hddldaemon_cfg="hddldaemon.cfg"

build_hddl_package()
{
        dockerfile="$DIR/Dockerfile.hddldaemon"
	gen_Dockerfile "$dockerfile"
	docker build -t ${ov_hddl}:${ov_hddl_version} $(env | grep -E '(proxy|PROXY)=' | sed 's/^/--build-arg /') -f "$dockerfile" "${DIR}"
        local container_id=$(docker create -it ${ov_hddl}:${ov_hddl_version} /bin/bash)
        docker cp $container_id:/root/package/${package_name}.tar.gz "$DIR"
        docker cp $container_id:/root/package/ov_ver.log "$DIR"
        #docker container rm $container_id
	#docker image rm ${ov_hddl}:${ov_hddl_version}
}

install_hddl_package()
{
        export LC_ALL=C
        apt-get install -y sudo libboost-filesystem1.58-dev nasm libboost-thread1.58-dev libboost-program-options1.58-dev libboost-all-dev libjson0-dev libusb-1.0-0-dev cmake libelf-dev
	ov_ver=`cat ov_ver.log`
	mkdir -p /opt/intel/
	tar zxf ${package_name}.tar.gz -C /opt/intel/
	mv /opt/intel/openvino /opt/intel/$ov_ver
        ln -s /opt/intel/$ov_ver /opt/intel/openvino
	cd /opt/intel/$ov_ver/deployment_tools/inference_engine/external/hddl/drivers/drv_ion 
        make && make install
        if [ $? != 0 ] ;then
		echo "[Error] Failed to install drv_ion"
	fi
        make clean
	cd /opt/intel/$ov_ver/deployment_tools/inference_engine/external/hddl/drivers/drv_vsc 
        make && make install
        if [ $? != 0 ] ;then
		echo "[Error] Failed to install drv_vsc"
	fi
        make clean

        # Load SMBus driver
	modprobe i2c-i801
	modprobe i2c-dev
}

gen_Dockerfile()
{
    cat > "$1" <<EOF
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y -q apt-utils lsb-release vim net-tools bzip2 wget curl git gcc g++ automake libtool pkg-config autoconf make cmake cmake-curses-gui gcc-multilib g++-multilib libboost-dev libssl-dev build-essential
RUN apt-get install -y build-essential libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl libffi-dev
RUN mkdir -p /root/package
RUN wget -P /root/package $py_link
RUN wget -P /root/package $ov_link
	
#install python3.7
RUN cd /root/package && \\
    tar xzf Python-$py_ver.tgz && \\
    cd Python-$py_ver && \\
    ./configure && \\
    make && make install

#install openvino
RUN cd /root/package && \\
    tar xzf $openvino_name.tgz && \\
    apt-get install -y cpio && \\
    cd $openvino_name && \\
    sed -i "s/ACCEPT_EULA=decline/ACCEPT_EULA=accept/" silent.cfg && \\
    bash install.sh --ignore-signature --cli-mode -s silent.cfg

RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \\
    python3 deployment_manager.py --targets=hddl --output_dir=/root/package --archive_name=${package_name}
RUN ls /opt/intel | grep  openvino_ > /root/package/ov_ver.log
EOF
}

setup_crontab()
{
    crontab - <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=""
@reboot (source /opt/intel/openvino/bin/setupvars.sh;modprobe myd_ion;modprobe i2c-i801;modprobe i2c-dev;while true; do /opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin/hddldaemon; sleep 30s; done) 2>&1 > /var/log/hddl-daemon.log
EOF
}

case "$0" in
    *install*)
        install_hddl_package "$@"
        setup_crontab
        ;;
    *setup*)
        build_hddl_package

        NODEUSER="root"
        for nodeip in $(sudo vcactl network ip 2>/dev/null | grep -E '^[0-9.]+$'); do
            echo "setup on $nodeip" $0
            scp "$0" $NODEUSER@$nodeip:/root/install-hddl.sh
            scp "$DIR/ov_ver.log" $NODEUSER@$nodeip:/root
	    scp "$DIR/${package_name}.tar.gz" $NODEUSER@$nodeip:/root

	    # install package on VCAC-A
            ssh $NODEUSER@$nodeip /root/install-hddl.sh
        done
        ;;
esac
