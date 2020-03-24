
FROM ubuntu:18.04 as builder
WORKDIR /home

# BUILD TOOLS for HDDLDAEMON image
RUN apt-get update && apt-get install -y --no-install-recommends cpio sudo python3-pip python3-setuptools wget libboost-filesystem1.65 libboost-thread1.65 libboost-program-options1.65 libjson-c-dev build-essential autoconf automake libtool kmod libelf-dev libusb-1.0-0 lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Build libusb
ARG LIBUSB_VER=v1.0.22
ARG LIBUSB_REPO=https://github.com/libusb/libusb/archive/${LIBUSB_VER}.tar.gz

RUN wget -O - ${LIBUSB_REPO} | tar xz && \
    cd libusb* && \
    ./autogen.sh enable_udev=no && \
    make -j $(nproc) && \
    cp ./libusb/.libs/libusb-1.0.so /lib/x86_64-linux-gnu/libusb-1.0.so.0

# OpenVINO verion
# 2020.1 and deployment manager script
ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2020.1.023
ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz


#Download and unpack OpenVino
RUN mkdir /tmp2
RUN wget ${OPENVINO_URL} -P /tmp2
RUN if [ -f /tmp2/${OPENVINO_BUNDLE}.tgz ]; \
    then tar xzvf /tmp2/${OPENVINO_BUNDLE}.tgz -C /tmp2 && rm /tmp2/${OPENVINO_BUNDLE}.tgz; \
    else echo "Please prepare the OpenVino installation bundle"; \
fi

# Create a silent configuration file for install
RUN echo "ACCEPT_EULA=accept" > /tmp2/silent.cfg                        && \
    echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> /tmp2/silent.cfg         && \
    echo "PSET_INSTALL_DIR=/opt/intel" >> /tmp2/silent.cfg              && \
    echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> /tmp2/silent.cfg   && \
    echo "COMPONENTS=DEFAULTS" >> /tmp2/silent.cfg                      && \
    echo "COMPONENTS=ALL" >> /tmp2/silent.cfg                           && \
    echo "PSET_MODE=install" >> /tmp2/silent.cfg                        && \
    echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> /tmp2/silent.cfg  && \
    echo "SIGNING_ENABLED=no" >> /tmp2/silent.cfg

#Install OpenVino
RUN /tmp2/${OPENVINO_BUNDLE}/install.sh --ignore-signature --cli-mode -s /tmp2/silent.cfg && rm -rf /tmp2



RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \
    python3 deployment_manager.py --targets=hddl --output_dir=/home --archive_name=hddl && \
    mkdir -p /home/opt/intel && \
    cd /home/opt/intel && \
    tar xvf /home/hddl.tar.gz


#Give all user exec permission
RUN chmod -R 775 /opt/intel/ ;





FROM ubuntu:18.04

# BUILD TOOLS for HDDLDAEMON run layer image
RUN apt-get update && apt-get install -y sudo libboost-filesystem1.65-dev nasm libboost-thread1.65-dev libboost-program-options1.65-dev libjson-c-dev libusb-1.0-0 autoconf automake make libtool kmod libelf-dev lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /lib/x86_64-linux-gnu/libusb-1.0.so.0 /lib/x86_64-linux-gnu/libusb-1.0.so.0
COPY --from=builder /home/opt/intel /opt/intel
COPY *_hddl.sh /usr/local/bin/
