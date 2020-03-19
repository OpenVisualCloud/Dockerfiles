# OpenVINO verion
# 2020.1 and deployment manager script
ARG OPENVINO_BUNDLE=l_openvino_toolkit_p_2020.1.023
ARG OPENVINO_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz

ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
#Install OpenVino dependencies
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends cpio joe nano sudo unzip wget less \
libpng12-dev libcairo2-dev libpango1.0-dev \
libglib2.0-dev libgtk2.0-dev libswscale-dev libavcodec-dev libavformat-dev build-essential \
cmake libusb-1.0-0-dev
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
#Install OpenVino dependencies
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

ifelse(index(DOCKER_IMAGE,-hddldaemon),-1,
ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ENV InferenceEngine_DIR=/opt/intel/openvino/deployment_tools/inference_engine/share
#ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH
,)dnl

ifelse(index(DOCKER_IMAGE,-hddldaemon),-1,
# OPENVINO C API
ARG DLDT_C_API_REPO=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/ffmpeg4.2_va/thirdparty/dldt-c-api/source/v2.0.1.tar.gz
RUN wget -O - ${DLDT_C_API_REPO} | tar xz && \
    cd dldt-c_api-2.0.1 && \
    mkdir -p build && cd build && \
    cmake -DENABLE_AVX512F=OFF .. && \
    make -j8 && \
    make install && \
    make install DESTDIR=/home/build
define(`FFMPEG_CONFIG_DLDT_IE',--enable-libinference_engine_c_wrapper )dnl
,)dnl

ifelse(index(DOCKER_IMAGE,-dev),-1,
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,
# Install python3.6 fpr deployment manager on ubuntu1604
RUN wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz       && \
    tar -xvf Python-3.6.3.tgz                                           && \
    cd Python-3.6.3                                                     && \
    ./configure                                                         && \
    make -j $(nproc)                                                    && \
    apt-get install -y checkinstall					&& \
    checkinstall --install=no --nodoc -y --pkgname=python36-from-source	

RUN cd Python-3.6.3							&& \ 
    dpkg -i python36-from-source_3.6.3-1_amd64.deb

#Deploy small package using deployment manager
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager/   && \
    python3.6 ./deployment_manager.py --targets hddl vpu cpu            && \
    cd /root/ && ls -lh                                                 && \
    tar zxf openvino_deploy_package.tar.gz                              && \
    mv openvino_deploy_package openvino

#Remove python3.6
RUN cd Python-3.6.3							&& \
    dpkg -r python36-from-source
)dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,
ifelse(index(DOCKER_IMAGE,hddldaemon),-1,
#Deploy small package using deployment manager
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager/   && \
    ./deployment_manager.py --targets hddl vpu cpu                      && \
    cd /root/ && ls -lh                                                 && \
    tar zxf openvino_deploy_package.tar.gz                              && \
    mv openvino_deploy_package openvino
,dnl
RUN cd /opt/intel/openvino/deployment_tools/tools/deployment_manager && \
    python3 deployment_manager.py --targets=hddl --output_dir=/home --archive_name=hddl && \
    mkdir -p /home/opt/intel && \
    cd /home/opt/intel && \
    tar xvf /home/hddl.tar.gz
),dnl
),dnl
#Remove components of OpenVino that won't be used
ARG CV_BASE_DIR=/opt/intel/openvino
RUN rm -rf ${CV_BASE_DIR}/uninstall* && \
    rm -rf ${CV_BASE_DIR}/python && \
    rm -rf ${CV_BASE_DIR}/documentation && \
    rm -rf ${CV_BASE_DIR}/install_dependiencies && \
    rm -rf ${CV_BASE_DIR}/openvino_toolkit_uninstaller && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/demo && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/intel_models && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/model_optimizer && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/tools && \
    rm -rf ${CV_BASE_DIR}/deployment_tools/inference_engine/samples && \
    rm -rf ${CV_BASE_DIR}/openvx/samples && \
    rm -rf ${CV_BASE_DIR}/opencv/samples
)dnl

ifelse(index(DOCKER_IMAGE,-hddldaemon),-1,
#Copy over directories to clean image
RUN mkdir -p /home/build/usr/local/lib && \
    mkdir -p /home/build/opt/intel && \
    mkdir -p /home/build/usr/lib && \
    cp -r /usr/local/lib/* /home/build/usr/local/lib/ && \
    ifelse(index(DOCKER_IMAGE,-dev),-1,cp -rH /root/openvino /home/build/opt/intel/,cp -rH /opt/intel/openvino /home/build/opt/intel/) && \
    ifelse(index(DOCKER_IMAGE,-dev),-1,cp /opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libinference_engine_preproc.so /home/build/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libinference_engine_preproc.so && \)
    cp -r /usr/lib/* /home/build/usr/lib
,)dnl

#Give all user exec permission
RUN chmod -R 775 /opt/intel/ ;

define(`INSTALL_OPENVINO',dnl
ENV IE_PLUGINS_PATH=/opt/intel/openvino/deployment_tools/inference_engine/lib/intel64
ENV HDDL_INSTALL_DIR=/opt/intel/openvino/deployment_tools/inference_engine/external/hddl
ifelse(index(DOCKER_IMAGE,-dev),-1,,ENV InferenceEngine_DIR=/opt/intel/openvino/deployment_tools/inference_engine/share
)dnl
#ENV OpenCV_DIR=/opt/intel/openvino/opencv/share/OpenCV
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:/usr/local/lib:$IE_PLUGINS_PATH
)dnl

define(`INSTALL_PKGS_OPENVINO',dnl
ifelse(index(DOCKER_IMAGE,ubuntu1604),-1,,libjson-c2 libboost-thread1.58.0 libboost-filesystem1.58.0 libboost-system1.58.0 libusb-1.0-0-dev) dnl
ifelse(index(DOCKER_IMAGE,ubuntu1804),-1,,libjson-c3 libboost-filesystem1.65.1 libboost-system1.65.1 libusb-1.0-0-dev libboost-program-options1.65.1) dnl
)dnl

