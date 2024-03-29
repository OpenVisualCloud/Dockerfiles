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

DECLARE(`LIBVA_UTILS_VER',2.15.0)
DECLARE(`LIBVA_UTILS_SRC_REPO',https://github.com/intel/libva-utils/archive/LIBVA_UTILS_VER.tar.gz)

#ifelse(OS_NAME,ubuntu,`
#define(`LIBVA2_BUILD_DEPS',`automake ca-certificates gcc libdrm-dev libtool make pkg-config wget ifelse(LIBVA2_X11,true,libx11-dev libxext-dev libxfixes-dev) ifelse(LIBVA2_WAYLAND,true,libwayland-dev)')

#define(`LIBVA2_INSTALL_DEPS',`libdrm2 ifelse(LIBVA2_X11,true,libx11-6 libxext6 libxfixes3) ifelse(LIBVA2_WAYLAND,true,libwayland-client0)')
#')

#ifelse(OS_NAME,centos,`
#define(`LIBVA2_BUILD_DEPS',`automake gcc libdrm-devel libtool make pkg-config wget which ifelse(LIBVA2_X11,true,libX11-devel libXfixes-devel libXext-devel) ifelse(LIBVA2_WAYLAND,true,wayland-devel)')

#define(`LIBVA2_INSTALL_DEPS',`libdrm ifelse(LIBVA2_X11,true,libX11 libXfixes libXext) ifelse(LIBVA2_WAYLAND,true,libwayland-client)')
#')

define(`BUILD_LIBVA_UTILS',`
# build libva-utils
ARG LIBVA_UTILS_REPO=LIBVA_UTILS_SRC_REPO
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
  wget -O - ${LIBVA_UTILS_REPO} | tar xz
RUN cd BUILD_HOME/libva-utils-LIBVA_UTILS_VER && \
  ./autogen.sh --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
  make -j"$(nproc)" && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install 
')

#define(`ENV_VARS_LIBVA2',`dnl
#ENV LIBVA_DRIVERS_PATH=BUILD_LIBDIR/dri
#ENV LIBVA_DRIVER_NAME=iHD
#ENV DISPLAY=:0.0
#')

REG(LIBVA_UTILS)

include(end.m4)dnl
