# OpenVINO verion
# R1.1
ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2019.1.144
ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/15512/l_openvino_toolkit_p_2019.1.144.tgz


#Install OpenVino dependencies
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends cpio joe nano sudo unzip wget less \
libpng12-dev libcairo2-dev libpango1.0-dev \
libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev build-essential \
cmake libusb-1.0-0-dev
#gstreamer1.0-plugins-base libgstreamer1.0-dev
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN yum install -y -q boost-devel glibc-static glibc-devel libstdc++-static libstdc++-devel libstdc++ libgcc libusbx-devel openblas-devel;
)dnl

define(`FFMPEG_CONFIG_DLDT_IE',--enable-libinference_engine )dnl

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

ARG C_API_VERSION=openvino_2019.1.133_9a10fc5
ARG C_API_TAR_REPO=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/dldt-c-api/dldt-c-api-${C_API_VERSION}.tgz

# OPENVINO C API
RUN mkdir -p /tmp2/c_api && \
    cd /tmp2/c_api && \
    wget -O - ${C_API_TAR_REPO} | tar xz && \
    cp -rf usr/* /usr && \
    cp -rf usr/* /home/build/usr && \
    cd ../.. && \
    rm -rf /tmp2

#Remove components of OpenVino that won't be used
ARG CV_BASE_DIR=/opt/intel/openvino
RUN rm -rf ${CV_BASE_DIR}/uninstall* && \
    rm -rf ${CV_BASE_DIR}/python && \
    rm -rf ${CV_BASE_DIR}/documentation && \
    rm -rf ${CV_BASE_DIR}/install_dependencies && \
    rm -rf ${CV_BASE_DIR}/openvino_toolkit_uninstaller && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/demo && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/intel_models && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/model_optimizer && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/tools && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/inference_engine/samples && \
    rm -rf ${CV_BASE_DIR}/openvx/samples && \
    rm -rf ${CV_BASE_DIR}/opencv/samples 


#Copy over directories to clean image
RUN mkdir -p /home/build/usr/local/lib && \
    mkdir -p /home/build/opt/intel && \
    mkdir -p /home/build/usr/lib && \
    cp -r /usr/local/lib/* /home/build/usr/local/lib/ && \
    cp -rH /opt/intel/openvino /home/build/opt/intel/ && \
    cp -r /usr/lib/* /home/build/usr/lib

ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH

RUN rm -rf /var/lib/apt/lists/*;

define(`INSTALL_OPENVINO',dnl
ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR="/opt/intel/openvino/deployment_tools/inference_engine/share"
ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:/usr/local/lib:$IE_PLUGINS_PATH
)dnl

define(`INSTALL_PKGS_OPENVINO',dnl
ifelse(index(DOCKER_IMAGE,ubuntu),-1,boost-devel,libboost-all-dev libusb-1.0-0-dev) dnl
)dnl

