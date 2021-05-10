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

include(nasm.m4)

DECLARE(`LIBVMAF_VER',2.1.1)

ifelse(OS_NAME,ubuntu,`
define(`LIBVMAF_BUILD_DEPS',`ca-certificates ifdef(`BUILD_MESON',,meson) tar g++ wget pkg-config ninja-build')
')

ifelse(OS_NAME,centos,`
define(`LIBVMAF_BUILD_DEPS',`ifdef(`BUILD_MESON',,meson) wget tar gcc-c++ ninja-build ifelse(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_LIBVMAF',`
# build VMAF
ARG VMAF_VER=LIBVMAF_VER
ARG LIBVMAF_REPO=https://github.com/Netflix/vmaf/archive/refs/tags/v${VMAF_VER}.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${LIBVMAF_REPO} | tar xz && ls
RUN cd BUILD_HOME/vmaf-LIBVMAF_VER/libvmaf && \
  ls && \ 
  ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ') meson build --prefix=BUILD_PREFIX --libdir BUILD_LIBDIR --buildtype=plain && \
  cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install ifelse(OS_NAME:OS_VERSION,centos:7,`)')
')

REG(LIBVMAF)

include(end.m4)dnl
