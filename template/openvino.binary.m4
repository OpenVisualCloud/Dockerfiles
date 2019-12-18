# OpenVINO verion
# R3 and deployment manager script
ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2019.3.334
ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334.tgz


#Install OpenVino dependencies
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends cpio joe nano sudo unzip wget less \
libpng12-dev libcairo2-dev libpango1.0-dev \
libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev build-essential \
cmake libusb-1.0-0-dev
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q boost-devel glibc-static glibc-devel libstdc++-static libstdc++-devel libstdc++ libgcc libusbx-devel openblas-devel;
)dnl

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

# Install python3.6 fpr deployment manager on ubuntu1604
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz	&& \
    tar -xvf Python-3.6.3.tgz						&& \
    cd Python-3.6.3							&& \
    ./configure								&& \
    make -j $(nproc)							&& \
    make install

#Deploy small package using deployment manager
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager/   && \
    python3.6 ./deployment_manager.py --targets hddl vpu cpu            && \
    cd /root/ && ls -lh                                                 && \
    tar zxf openvino_deploy_package.tar.gz
)dnl

#Deploy small package using deployment manager
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager/   && \
    ./deployment_manager.py --targets hddl vpu cpu			&& \
    cd /root/ && ls -lh                                                 && \
    tar zxf openvino_deploy_package.tar.gz
)dnl

#Copy over directories to clean image
RUN mkdir -p /home/build/usr/local/lib && \
    mkdir -p /home/build/opt/intel && \
    mkdir -p /home/build/usr/lib && \
    cp -r /usr/local/lib/* /home/build/usr/local/lib/ && \
    cp -rH /root/openvino /home/build/opt/intel/ && \
    cp -r /usr/lib/* /home/build/usr/lib

ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH

RUN rm -rf /var/lib/apt/lists/*;

# OPENVINO C API
ARG DLDT_C_API_REPO=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/ffmpeg4.1_va/thirdparty/dldt-c-api/source/dldt-c_api_v2-1.0.1.tar.gz
RUN wget -O - ${DLDT_C_API_REPO} | tar xz && \
    cd dldt-c_api-1.0.1 && \
    mkdir -p build && cd build && \
    cmake -DENABLE_AVX512F=OFF .. && \
    make -j8 && \
    make install && \
    make install DESTDIR=/home/build
define(`FFMPEG_CONFIG_DLDT_IE',--enable-libinference_engine_c_api )dnl

define(`INSTALL_OPENVINO',dnl
ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:/usr/local/lib:$IE_PLUGINS_PATH
)dnl

define(`INSTALL_PKGS_OPENVINO',dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,libjson-c2 libboost-thread1.58.0 libboost-filesystem1.58.0 libboost-system1.58.0 libusb-1.0-0-dev) dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,libjson-c3 libboost-filesystem1.65.1 libboost-system1.65.1 libusb-1.0-0-dev) dnl
)dnl

