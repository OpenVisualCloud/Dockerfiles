
FROM ubuntu:18.04 as builder
WORKDIR /home

RUN apt-get update && apt-get install -y --no-install-recommends \
    cpio sudo python3-pip python3-setuptools wget \
    libboost-filesystem1.65 libboost-thread1.65 libboost-program-options1.65 \
    libjson-c-dev build-essential autoconf automake libtool \
    kmod libelf-dev libusb-1.0-0 lsb-release && \
    rm -rf /var/lib/apt/lists/*

ARG LIBUSB_VER=v1.0.22
ARG LIBUSB_REPO=https://github.com/libusb/libusb/archive/${LIBUSB_VER}.tar.gz

RUN wget -O - ${LIBUSB_REPO} | tar xz && \
    cd libusb* && \
    ./autogen.sh enable_udev=no && \
    make -j $(nproc) && \
    cp ./libusb/.libs/libusb-1.0.so /lib/x86_64-linux-gnu/libusb-1.0.so.0

ARG OPENVINO_VER=2019.3.334
ARG OPENVINO_REPO=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_${OPENVINO_VER}.tgz

RUN wget -O - ${OPENVINO_REPO} | tar xz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg

RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \
    python3 deployment_manager.py --targets=hddl --output_dir=/home --archive_name=hddl && \
    mkdir -p /home/opt/intel && \
    cd /home/opt/intel && \
    tar xvf /home/hddl.tar.gz

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo libboost-filesystem1.65-dev nasm \
    libboost-thread1.65-dev libboost-program-options1.65-dev libjson-c-dev \
    libusb-1.0-0 autoconf automake make libtool kmod libelf-dev lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /lib/x86_64-linux-gnu/libusb-1.0.so.0 /lib/x86_64-linux-gnu/libusb-1.0.so.0
COPY --from=builder /home/opt/intel /opt/intel
COPY *_hddl.sh /usr/local/bin/
