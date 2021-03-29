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

include(libva2.m4)
include(gmmlib.m4)

DECLARE(`MEDIA_DRIVER_VER',intel-media-20.2.0)
DECLARE(`MEDIA_DRIVER_SRC_REPO',https://github.com/intel/media-driver/archive/MEDIA_DRIVER_VER.tar.gz)
DECLARE(`ENABLE_PRODUCTION_KMD',OFF)

ifelse(OS_NAME,ubuntu,`
define(`MEDIA_DRIVER_BUILD_DEPS',`ca-certificates ifdef(`BUILD_CMAKE',,cmake) g++ libpciaccess-dev make pkg-config wget')
define(`MEDIA_DRIVER_INSTALL_DEPS',`libpciaccess0')
')

ifelse(OS_NAME,centos,`
define(`MEDIA_DRIVER_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake) gcc-c++ libpciaccess-devel make pkg-config wget ifelse(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_MEDIA_DRIVER',`
# build media driver
ARG MEDIA_DRIVER_REPO=MEDIA_DRIVER_SRC_REPO
RUN cd BUILD_HOME && \
  wget -O - ${MEDIA_DRIVER_REPO} | tar xz
RUN cd BUILD_HOME/media-driver-MEDIA_DRIVER_VER && mkdir build && cd build && \
  ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')cmake -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR -DENABLE_PRODUCTION_KMD=ENABLE_PRODUCTION_KMD .. && \
  make -j$(nproc)ifelse(OS_NAME:OS_VERSION,centos:7,` )') && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
')

REG(MEDIA_DRIVER)

include(end.m4)dnl
