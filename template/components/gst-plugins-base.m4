dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2020, Intel Corporation
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

include(gst-core.m4)

dnl Optional libraries can set ON or OFF different plugins inside this base gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this base gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-base/blob/master/REQUIREMENTS
DECLARE(`GST_XLIB',true)
DECLARE(`GST_ALSA',true)
DECLARE(`GST_PANGO',true)
DECLARE(`GST_THEORA',true)
DECLARE(`GST_LIBVISUAL',true)
DECLARE(`GST_OPENGL',true)

define(`GST_XLIB_BUILD',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-dev libxv-dev libxt-dev,
OS_NAME,centos,libX11-devel libXv-devel libXt-devel)'))dnl

define(`GST_XLIB_INSTALL',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-6 libxv1 libxt6,
OS_NAME,centos,libX11 libXv libXt)'))dnl

define(`GST_ALSA_BUILD',dnl
ifelse(GST_ALSA,true,`ifelse(
OS_NAME,ubuntu,libasound2-dev,
OS_NAME,centos,alsa-lib-devel)'))dnl

define(`GST_ALSA_INSTALL',dnl
ifelse(GST_ALSA,true,`ifelse(
OS_NAME,ubuntu,libasound2,
OS_NAME,centos,alsa-lib)'))dnl

define(`GST_PANGO_BUILD',dnl
ifelse(GST_PANGO,true,`ifelse(
OS_NAME,ubuntu,libpango1.0-dev,
OS_NAME,centos,pango-devel)'))dnl

define(`GST_PANGO_INSTALL',dnl
ifelse(GST_PANGO,true,`ifelse(
OS_NAME,ubuntu,libpangocairo-1.0-0 libcairo-gobject2,
OS_NAME,centos,pango)'))dnl

define(`GST_THEORA_BUILD',dnl
ifelse(GST_THEORA,true,`ifelse(
OS_NAME,ubuntu,libtheora-dev,
OS_NAME,centos,libtheora)'))dnl

define(`GST_THEORA_INSTALL',dnl
ifelse(GST_THEORA,true,`ifelse(
OS_NAME,ubuntu,libtheora0,
OS_NAME,centos,libtheora)'))dnl

define(`GST_LIBVISUAL_BUILD',dnl
ifelse(GST_LIBVISUAL,true,`ifelse(
OS_NAME,ubuntu,libvisual-0.4-dev,
OS_NAME,centos,libvisual)'))dnl

define(`GST_LIBVISUAL_INSTALL',dnl
ifelse(GST_LIBVISUAL,true,`ifelse(
OS_NAME,ubuntu,libvisual-0.4-0,
OS_NAME,centos,libvisual)'))dnl

define(`GST_OPENGL_BUILD',dnl
ifelse(GST_OPENGL,true,`ifelse(
OS_NAME,ubuntu,libgl1-mesa-dev,
OS_NAME,centos,mesa-libGL-devel)'))dnl

define(`GST_OPENGL_INSTALL',dnl
ifelse(GST_OPENGL,true,`ifelse(
OS_NAME,ubuntu,libegl1-mesa,
OS_NAME,centos,mesa-libGL)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBASE_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_XLIB_BUILD GST_ALSA_BUILD GST_PANGO_BUILD GST_THEORA_BUILD GST_LIBVISUAL_BUILD GST_OPENGL_BUILD')'
`define(`GSTBASE_INSTALL_DEPS',`libglib2.0-0 GST_XLIB_INSTALL GST_ALSA_INSTALL GST_PANGO_INSTALL GST_THEORA_INSTALL GST_LIBVISUAL_INSTALL GST_OPENGL_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTBASE_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_XLIB_BUILD GST_ALSA_BUILD GST_PANGO_BUILD GST_THEORA_BUILD GST_LIBVISUAL_BUILD GST_OPENGL_BUILD')'
`define(`GSTBASE_INSTALL_DEPS',`glib2  mesa-libEGL GST_XLIB_INSTALL GST_ALSA_INSTALL GST_PANGO_INSTALL GST_THEORA_INSTALL GST_LIBVISUAL_INSTALL GST_OPENGL_INSTALL')'
)

define(`BUILD_GSTBASE',
ARG GSTBASE_REPO=https://github.com/GStreamer/gst-plugins-base/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${GSTBASE_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-base-GSTCORE_VER && \
  meson build \
    --prefix=BUILD_PREFIX \
    --libdir=BUILD_LIBDIR \
    --libexecdir=BUILD_LIBDIR \
    --buildtype=plain \
    -Dexamples=disabled \
    -Dtests=disabled \
    -Dgtk_doc=disabled && \
  cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install
)

REG(GSTBASE)

include(end.m4)
