#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))
openvino_name="l_openvino_toolkit_p_2019.3.334"
ov_link="http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/$openvino_name.tgz"
py_ver='3.7.2'
py_link="https://www.python.org/ftp/python/$py_ver/Python-$py_ver.tgz"
pack_dir="$( cd "$(dirname "$0")" && pwd )"
package_name="intel-vcaa-hddl"
ov_hddl="ov_hddl"
ov_hddl_version="v1"
hddldaemon_cfg="hddldaemon.cfg"

build_hddl_package()
{
	gen_Dockerfile
	docker build -t ${ov_hddl}:${ov_hddl_version} $(env | grep -E '(proxy|REPO|VER)=' | sed 's/^/--build-arg /') ${DIR}
        docker run --rm $(env | grep -E '(proxy)=' | sed 's/^/-e /') ${ov_hddl}:${ov_hddl_version}
        local container_id=`docker ps -a |grep ${ov_hddl}:${ov_hddl_version} | awk '{ print $1 }'`
        for cont_id in $container_id;
        do
        	container_id=$cont_id
        	break
        done
        docker cp $container_id:/root/package/${package_name}.tar.gz $pack_dir
        docker cp  $container_id:/root/package/ov_ver.log $pack_dir
}

transfer_hddl_package()
{

	image="$1"
	worker="root@$nodeip"
 
	echo "Update image: $image to $worker"
	echo "Transfering image..."
	scp "$image" $NODEUSER@$nodeip:/root/${package_name}.tar.gz 
}

install_hddl_package()
{
	ov_ver=`cat ov_ver.log`
	mkdir -p /opt/intel/
	tar zxf ${package_name}.tar.gz -C /opt/intel/
	mv /opt/intel/openvino /opt/intel/$ov_ver
        ln -s /opt/intel/$ov_ver /opt/intel/openvino
        export LC_ALL=C
        apt-get install -y cmake libelf-dev
	cd /opt/intel/$ov_ver/deployment_tools/inference_engine/external/hddl/drivers/drv_ion 
        make && make install
        if [ $? != 0 ] ;then
		echo "[Error] Failed to install drv_ion"
	fi
	cd /opt/intel/$ov_ver/deployment_tools/inference_engine/external/hddl/drivers/drv_vsc 
        make && make install
        if [ $? != 0 ] ;then
		echo "[Error] Failed to install drv_vsc"
	fi

        # Load SMBus driver
	modprobe i2c-i801
	modprobe i2c-dev
}

gen_Dockerfile()
{
	cat > $pack_dir/Dockerfile <<EOF
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

cron_cfg()
{
	cat > $pack_dir/$hddldaemon_cfg <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=""
@reboot (source /opt/intel/openvino/bin/setupvars.sh;modprobe i2c-i801;modprobe i2c-dev;/opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin/hddldaemon)  >> /var/log/hddl-daemon.log
@hourly (source /opt/intel/openvino/bin/setupvars.sh;modprobe i2c-i801;modprobe i2c-dev;/opt/intel/openvino/deployment_tools/inference_engine/external/hddl/bin/hddldaemon)  >> /var/log/hddl-daemon.log
EOF
}

rm_docker_image()
{

	docker_imag_id=`docker images -a |grep ${ov_hddl} | awk '{ print $3 }'`
	docker rmi -f $docker_imag_id

}

case "$0" in
    *install*)
        install_hddl_package "$@"
        ;;
    *setup*)
        build_hddl_package
        cron_cfg

        NODEUSER="root"
        NODEPREFIX="172.32"
        sudo vcactl blockio list 2> /dev/null
        for nodeip in $(sudo vcactl network ip |grep $NODEPREFIX 2>/dev/null); do
            echo "setup on $nodeip" $0
            scp "$0" $NODEUSER@$nodeip:/root/install-hddl.sh
            scp $pack_dir/ov_ver.log $NODEUSER@$nodeip:/root/ov_ver.log

            transfer_hddl_package $pack_dir/${package_name}.tar.gz "$nodeip"
	    # install package on VCAC-A
            ssh $NODEUSER@$nodeip /root/install-hddl.sh

            # run the hddldaemon as the cron 
            scp $pack_dir/$hddldaemon_cfg $NODEUSER@$nodeip:/root/$hddldaemon_cfg
	    ssh $NODEUSER@$nodeip crontab $hddldaemon_cfg
        done

	#rm_docker_image
        ;;
esac

