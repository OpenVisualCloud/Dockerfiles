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

DECLARE(`DAV1D_VER',0.7.1)

ifelse(OS_NAME,ubuntu,`
define(`DAV1D_BUILD_DEPS',`ca-certificates ifdef(`BUILD_MESON',,meson) tar g++ wget pkg-config')
')

ifelse(OS_NAME,centos,`
define(`DAV1D_BUILD_DEPS',`ifdef(`BUILD_MESON',,meson) wget tar gcc-c++')
')

define(`BUILD_DAV1D',`
# build dav1d
ARG DAV1D_REPO=https://code.videolan.org/videolan/dav1d/-/archive/DAV1D_VER/dav1d-DAV1D_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${DAV1D_REPO} | tar xz
RUN cd BUILD_HOME/dav1d-DAV1D_VER && \
  meson build --prefix=BUILD_PREFIX --libdir BUILD_LIBDIR --buildtype=plain && \
  cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install
')

REG(DAV1D)

include(end.m4)dnl
