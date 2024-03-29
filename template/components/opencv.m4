dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2023, Intel Corporation
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

DECLARE(`OPENCV_VER',4.5.3-openvino-2021.4.2)
DECLARE(`OPENCV_VER_TRUNC',4.5.3)

ifelse(OS_NAME,ubuntu,`
define(`OPENCV_BUILD_DEPS',`ca-certificates ifdef(`BUILD_CMAKE',,cmake) gcc g++ make wget python3-numpy ccache libeigen3-dev')
')

ifelse(OS_NAME,centos,`
define(`OPENCV_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake3) gcc gcc-c++ make wget python36-numpy ccache eigen3-devel ifelse(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_OPENCV',`
# build opencv
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/OPENCV_VER.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
  wget -O - ${OPENCV_REPO} | tar xz
# TODO: file a bug against opencv since they do not accept full libdir
RUN cd BUILD_HOME/opencv-OPENCV_VER && mkdir build && cd build && \
  ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=patsubst(BUILD_LIBDIR,BUILD_PREFIX/) \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_OPENJPEG=OFF \
    -DWITH_JASPER=OFF \
    .. && \
  make -j "$(nproc)" && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install ifelse(OS_NAME:OS_VERSION,centos:7,` )')
')

define(`REBUILD_OPENCV_VIDEOIO',`
RUN cd BUILD_HOME/opencv-OPENCV_VER/build && \
  rm -rf ./* && \
  ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=patsubst(BUILD_LIBDIR,BUILD_PREFIX/) \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_OPENJPEG=OFF \
    -DWITH_JASPER=OFF \
    .. && \
  cd modules/videoio && \
  make -j "$(nproc)" && \
  cp -f ../../lib/libopencv_videoio.so.OPENCV_VER_TRUNC defn(`BUILD_DESTDIR',`BUILD_LIBDIR')ifelse(OS_NAME:OS_VERSION,centos:7,` )')
')

REG(OPENCV)

include(end.m4)dnl
