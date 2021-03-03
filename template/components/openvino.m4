dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`OPENVINO_VER',2021.2)
DECLARE(`OPENVINO_BUNDLE',l_openvino_toolkit_p_2021.2.185)
DECLARE(`OPENVINO_BUILD_NO',17504)

ifelse(OS_NAME,ubuntu,`
define(`OPENVINO_BUILD_DEPS',`cpio libjson-c-dev')
define(`OPENVINO_INSTALL_DEPS',`libusb-1.0-0-dev ifelse(OS_VERSION,20.04,libboost-filesystem1.67.0 libboost-system1.67.0 libboost-program-options1.67.0 libjson-c4,libboost-filesystem1.65.1 libboost-system1.65.1 libboost-program-options1.65.1 libjson-c3)')
')

define(`BUILD_OPENVINO',`
# Install OpenVINO - Closed source dldt
ARG OPENVINO_REPO=http://registrationcenter-download.intel.com/akdlm/irc_nas/OPENVINO_BUILD_NO/OPENVINO_BUNDLE.tgz

#Download and unpack OpenVino
RUN mkdir BUILD_HOME/openvino
RUN wget ${OPENVINO_REPO} -P BUILD_HOME/openvino
RUN if [ -f BUILD_HOME/openvino/OPENVINO_BUNDLE.tgz ]; \
    then tar xzvf BUILD_HOME/openvino/OPENVINO_BUNDLE.tgz -C BUILD_HOME/openvino && rm BUILD_HOME/openvino/OPENVINO_BUNDLE.tgz; \
    else echo "Please prepare the OpenVino installation bundle"; \
fi

# Create a silent configuration file for install
RUN echo "ACCEPT_EULA=accept" > BUILD_HOME/openvino/silent.cfg                        && \
    echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> BUILD_HOME/openvino/silent.cfg         && \
    echo "PSET_INSTALL_DIR=/opt/intel" >> BUILD_HOME/openvino/silent.cfg              && \
    echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> BUILD_HOME/openvino/silent.cfg   && \
    echo "COMPONENTS=DEFAULTS" >> BUILD_HOME/openvino/silent.cfg                      && \
    echo "COMPONENTS=ALL" >> BUILD_HOME/openvino/silent.cfg                           && \
    echo "PSET_MODE=install" >> BUILD_HOME/openvino/silent.cfg                        && \
    echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> BUILD_HOME/openvino/silent.cfg  && \
    echo "SIGNING_ENABLED=no" >> BUILD_HOME/openvino/silent.cfg

#Install OpenVino
RUN BUILD_HOME/openvino/OPENVINO_BUNDLE/install.sh --ignore-signature --cli-mode -s BUILD_HOME/openvino/silent.cfg && rm -rf BUILD_HOME/openvino

#Create symlink to assure compatibility with components
RUN cd /opt/intel/      &&\
    ln -s openvino_2021 openvino

ARG OPENVINO_IE_DIR=/opt/intel/openvino/deployment_tools/inference_engine

ENV IE_PLUGINS_PATH=${OPENVINO_IE_DIR}/lib/intel64
ENV HDDL_INSTALL_DIR=${OPENVINO_IE_DIR}/external/hddl
ENV InferenceEngine_DIR=${OPENVINO_IE_DIR}/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:${OPENVINO_IE_DIR}/external/gna/lib:${OPENVINO_IE_DIR}/external/mkltiny_lnx/lib:${OPENVINO_IE_DIR}/external/omp/lib:${OPENVINO_IE_DIR}/external/tbb/lib:/opt/intel/openvino/openvx/lib:$IE_PLUGINS_PATH

#Remove components of OpenVino that are not needed
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

#Copy over directories to run image
RUN mkdir -p BUILD_DESTDIR/opt/intel && \
    cp -rH /opt/intel/openvino BUILD_DESTDIR/opt/intel/
')

define(`INSTALL_OPENVINO',`
ARG OPENVINO_IE_DIR=/opt/intel/openvino/deployment_tools/inference_engine
ENV IE_PLUGINS_PATH=${OPENVINO_IE_DIR}/lib/intel64
ENV HDDL_INSTALL_DIR=${OPENVINO_IE_DIR}/external/hddl
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/deployment_tools/ngraph/lib:/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/gna/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/mkltiny_lnx/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/omp/lib:/opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib:/opt/intel/openvino/openvx/lib:/usr/local/lib:$IE_PLUGINS_PATH
')

define(`FFMPEG_PATCH_ANALYTICS',`
ARG FFMPEG_MA_RELEASE_VER=0.5
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=BUILD_HOME/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN cd BUILD_HOME && wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz
RUN cp ${FFMPEG_MA_PATH}/docker/patch/opencv.p BUILD_LIBDIR/pkgconfig
ARG CVDEF_H=/usr/local/include/opencv4/opencv2/core/cvdef.h
RUN if [ -f "${CVDEF_H}" ]; then cp ${FFMPEG_MA_PATH}/docker/patch/cvdef.h ${CVDEF_H}; fi
RUN cd $1 && \
    find ${FFMPEG_MA_PATH}/patches -type f -name "*.patch" -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;
')

REG(OPENVINO)

include(end.m4)dnl
