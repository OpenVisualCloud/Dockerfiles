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

include(gst-plugins-bad.m4)

ifelse(OS_NAME,ubuntu,`
define(`GSTVAAPI_BUILD_DEPS',`ca-certificates ifdef(`BUILD_MESON',,meson) tar g++ wget pkg-config libdrm-dev libglib2.0-dev libudev-dev flex bison ifdef(`ENABLE_INTEL_GFX_REPO',libva-dev)')

define(`GSTVAAPI_INSTALL_DEPS',`libdrm2 libglib2.0-0 libpciaccess0 libgl1-mesa-glx ifdef(`ENABLE_INTEL_GFX_REPO',libva2 libva-drm2 libva-x11-2 libva-wayland2)' ifelse(OS_NAME:OS_VERSION,ubuntu:20.04,libgles2))
')

ifelse(OS_NAME,centos,`
define(`GSTVAAPI_BUILD_DEPS',`ifdef(`BUILD_MESON',,meson) wget tar gcc-c++ glib2-devel libdrm-devel bison flex')
define(`GSTVAAPI_INSTALL_DEPS',`glib2 libdrm libpciaccess')
')

define(`BUILD_GSTVAAPI',`
# patch gst-vaapi with gst-video-analytics patch
ARG GST_PLUGIN_VAAPI_PATCH_VER=v1.0.0
ARG GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS=https://github.com/opencv/gst-video-analytics.git

# build gst-plugin-vaapi
ARG GSTVAAPI_REPO=https://github.com/GStreamer/gstreamer-vaapi/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${GSTVAAPI_REPO} | tar xz

RUN cd BUILD_HOME/gstreamer-vaapi-GSTCORE_VER && \
  git clone ${GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS} && \
  cd gst-video-analytics && git checkout ${GST_PLUGIN_VAAPI_PATCH_VER} && \
  cd .. && \
  git apply gst-video-analytics/patches/gstreamer-vaapi/vasurface_qdata.patch && \
  rm -fr gst-video-analytics

RUN cd BUILD_HOME/gstreamer-vaapi-GSTCORE_VER && \
  meson build \
    --prefix=BUILD_PREFIX \
    --libdir=BUILD_LIBDIR \
    --libexecdir=BUILD_LIBDIR \
    --buildtype=release \
    -Dexamples=disabled \
    -Dtests=disabled && \
  cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install
')

define(`ENV_VARS_GSTVAAPI',`dnl
ENV GST_VAAPI_ALL_DRIVERS=1
')

REG(GSTVAAPI)

include(end.m4)
