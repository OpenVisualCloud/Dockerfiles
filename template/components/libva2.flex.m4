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

DECLARE(`LIBVA2_VER',2.15.0)
DECLARE(`LIBVA2_SRC_REPO',https://github.com/intel/libva/archive/LIBVA2_VER.tar.gz)
DECLARE(`LIBVA2_X11',true)
DECLARE(`LIBVA2_WAYLAND',true)

ifelse(OS_NAME,ubuntu,`
define(`LIBVA2_BUILD_DEPS',`automake ca-certificates gcc libdrm-dev libtool make pkg-config wget ifelse(LIBVA2_X11,true,libx11-dev libxext-dev libxfixes-dev) ifelse(LIBVA2_WAYLAND,true,libwayland-dev)')

define(`LIBVA2_INSTALL_DEPS',`libdrm2 ifelse(LIBVA2_X11,true,libx11-6 libxext6 libxfixes3) ifelse(LIBVA2_WAYLAND,true,libwayland-client0)')
')


define(`BUILD_LIBVA2',`
# build libva2
ARG LIBVA2_REPO=LIBVA2_SRC_REPO
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
  wget -O - ${LIBVA2_REPO} | tar xz
RUN cd BUILD_HOME/libva-LIBVA2_VER && \
  ./autogen.sh --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
  make -j"$(nproc)" && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
')

define(`FFMPEG_PATCH_VAAPI',`dnl
ARG FFMPEG_PATCH_VAAPI_REPO=https://github.com/OpenVisualCloud/Dockerfiles-Resources/raw/master/ffmpeg-patch-0041-lavc-vaapi_encode_h265-fix-max_transform_hierarchy_d.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_PATCH_VAAPI_REPO} | tar xz && \
    cd $1 && \
    patch -p1 < ../0041-lavc-vaapi_encode_h265-fix-max_transform_hierarchy_d.patch || true
')

define(`ENV_VARS_LIBVA2',`dnl
ENV LIBVA_DRIVERS_PATH=BUILD_LIBDIR/dri
ENV LIBVA_DRIVER_NAME=iHD
ENV DISPLAY=:0.0
')

REG(LIBVA2)

include(end.m4)dnl
