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
include(opencv.m4)

DECLARE(`DLDT_VER',2021.4.2)
DECLARE(`DLDT_WARNING_AS_ERRORS',false)

ifelse(OS_NAME,ubuntu,`
define(`DLDT_BUILD_DEPS',`ca-certificates ifdef(`BUILD_CMAKE',,cmake) gcc g++ git libboost-all-dev libgtk2.0-dev libgtk-3-dev libtool libusb-1.0-0-dev make python python-yaml xz-utils libnuma-dev ocl-icd-opencl-dev opencl-headers')
define(`DLDT_INSTALL_DEPS',`libgtk-3-0 libnuma1 ocl-icd-libopencl1')
')

ifelse(OS_NAME,centos,`
define(`DLDT_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake3) gcc gcc-g++ git boost-devel gtk2-devel gtk3-devel libtool libusb-devel make python python2-yamlordereddictloader xz numactl-devel ocl-icd-devel opencl-headers')
define(`DLDT_INSTALL_DEPS',`gtk3 numactl ocl-icd')
')

define(`BUILD_DLDT',`
# build dldt
ARG DLDT_REPO=https://github.com/openvinotoolkit/openvino.git
RUN git clone -b DLDT_VER --depth 1 ${DLDT_REPO} BUILD_HOME/openvino && \
  cd BUILD_HOME/openvino && \
  git submodule update --init --recursive

RUN cd BUILD_HOME/openvino && \
  ifelse(DLDT_WARNING_AS_ERRORS,false,`dnl
  sed -i s/-Werror//g $(grep -ril Werror inference-engine/thirdparty/) && \
')dnl
  mkdir build && cd build && \
  ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX/openvino \
    -DENABLE_CPPLINT=OFF \
    -DENABLE_GNA=OFF \
    -DENABLE_VPU=OFF \
    -DENABLE_OPENCV=OFF \
    -DENABLE_MKL_DNN=ON \
    -DENABLE_CLDNN=ON \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DTREAT_WARNING_AS_ERROR=ifelse(DLDT_WARNING_AS_ERRORS,false,OFF,ON) \
    -DNGRAPH_WARNINGS_AS_ERRORS=ifelse(DLDT_WARNING_AS_ERRORS,false,OFF,ON) \
    -DNGRAPH_UNIT_TEST_ENABLE=OFF \
    -DNGRAPH_TEST_UTIL_ENABLE=OFF \
    .. && \
  make -j $(nproc) && \
  make install && \
  make install DESTDIR=BUILD_DESTDIR ifelse(OS_NAME:OS_VERSION,centos:7,` )')


ARG OPENVINO_INSTALL_DIR=/usr/local/openvino
ARG IE_INSTALL_DIR=${OPENVINO_INSTALL_DIR}/deployment_tools/inference_engine/

ENV InferenceEngine_DIR=${IE_INSTALL_DIR}/share
ENV TBB_DIR=${IE_INSTALL_DIR}/external/tbb/cmake
ENV ngraph_DIR=${OPENVINO_INSTALL_DIR}/deployment_tools/ngraph/cmake
')

define(`INSTALL_DLDT',`
# install DLDT
ARG CUSTOM_IE_DIR=BUILD_PREFIX/openvino/deployment_tools/inference_engine
ARG CUSTOM_IE_LIBDIR=${CUSTOM_IE_DIR}/lib/intel64
RUN printf "${CUSTOM_IE_LIBDIR}\n${CUSTOM_IE_DIR}/external/tbb/lib\n" >/etc/ld.so.conf.d/openvino.conf && ldconfig
')

define(`ENV_VARS_DLDT',`
ENV InferenceEngine_DIR=BUILD_PREFIX/openvino/deployment_tools/inference_engine/share
ENV TBB_DIR=BUILD_PREFIX/openvino/deployment_tools/inference_engine/external/tbb/cmake
ENV ngraph_DIR=BUILD_PREFIX/openvino/deployment_tools/ngraph/cmake
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:BUILD_PREFIX/openvino/deployment_tools/ngraph/lib/
')

define(`FFMPEG_PATCH_ANALYTICS',
ARG FFMPEG_MA_RELEASE_VER=0.5
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=BUILD_HOME/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN cd BUILD_HOME && wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz
RUN cp ${FFMPEG_MA_PATH}/docker/patch/opencv.pc BUILD_LIBDIR/pkgconfig
ARG CVDEF_H=/usr/local/include/opencv4/opencv2/core/cvdef.h
RUN if [ -f "${CVDEF_H}" ]; then cp ${FFMPEG_MA_PATH}/docker/patch/cvdef.h ${CVDEF_H}; fi
RUN cd $1 && \
    find ${FFMPEG_MA_PATH}/patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;
)

define(`CLEANUP_DLDT',`dnl
ifelse(CLEANUP_CC,yes,`dnl
RUN cd defn(`BUILD_DESTDIR',`BUILD_PREFIX')/openvino/deployment_tools/inference_engine && \
    rm -rf defn(`BUILD_DESTDIR',`BUILD_LIBDIR')/pkgconfig/openvino.pc \
       include src share/*.cmake cmake lib/intel64/*.a external/tbb/include external/tbb/cmake
')dnl
ifelse(CLEANUP_DOC,yes,`dnl
RUN rm -rf defn(`BUILD_DESTDIR',`BUILD_PREFIX')/openvino/inference-engine/external/tbb/doc
')dnl
')

REG(DLDT)

include(end.m4)dnl
