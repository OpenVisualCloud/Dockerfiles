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

ifelse(OS_NAME,ubuntu,`
define(`GSTBASE_BUILD_DEPS',`ca-certificates ifdef(`BUILD_MESON',,meson) tar g++ gobjc wget pkg-config libglib2.0-dev flex bison gobject-introspection libgirepository1.0-dev ifelse(GST_XLIB,true,libx11-dev libxv-dev libxt-dev) ifelse(GST_ALSA,true,libasound2-dev) ifelse(GST_PANGO,true,libpango1.0-dev) ifelse(GST_THEORA,true,libtheora-dev) ifelse(GST_LIBVISUAL,true,libvisual-0.4-dev) ifelse(GST_OPENGL,true,libgl1-mesa-dev libx11-xcb-dev)')

define(`GSTBASE_INSTALL_DEPS',`libglib2.0-0 ifelse(GST_XLIB,true,libx11-6 libxv1 libxt6) ifelse(GST_ALSA,true,libasound2) ifelse(GST_PANGO,true,libpangocairo-1.0-0 libcairo-gobject2) ifelse(GST_THEORA,true,libtheora0) ifelse(GST_LIBVISUAL,true,libvisual-0.4-0) ifelse(GST_OPENGL,true,libgl1-mesa-dri libgl1-mesa-glx libegl1-mesa)')
')

ifelse(OS_NAME,centos,`
define(`GSTBASE_BUILD_DEPS',`ifdef(`BUILD_MESON',,meson) wget tar gcc gcc-objc gcc-c++ glib2-devel bison flex gobject-introspection-devel ifelse(GST_XLIB,true,libX11-devel libXv-devel libXt-devel) ifelse(GST_ALSA,true,alsa-lib-devel) ifelse(GST_PANGO,true,libpango1.0-dev pango-devel) ifelse(GST_THEORA,true,libtheora-devel) ifelse(GST_LIBVISUAL,true,libvisual-devel) ifelse(GST_OPENGL,true,libegl1-mesa mesa-libGL-devel)')

define(`GSTBASE_INSTALL_DEPS',`glib2 mesa-libEGL gobject-introspection ifelse(GST_XLIB,true,libX11 libXv libXt) ifelse(GST_ALSA,true,alsa-lib) ifelse(GST_PANGO,true,pango) ifelse(GST_THEORA,true,libtheora) ifelse(GST_LIBVISUAL,true,libvisual) ifelse(GST_OPENGL,true,mesa-libGL)')
')

define(`BUILD_GSTBASE',`
# build gst-plugin-base
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
    -Ddoc=disabled \
    -Dintrospection=enabled \
    -Dgtk_doc=disabled \
    -Dalsa=ifelse(GST_ALSA,true,enabled,disabled) \
    -Dpango=ifelse(GST_PANGO,true,enabled,disabled) \
    -Dtheora=ifelse(GST_THEORA,true,enabled,disabled) \
    -Dlibvisual=ifelse(GST_LIBVISUAL,true,enabled,disabled) \
    -Dgl=ifelse(GST_OPENGL,true,enabled,disabled) \
  && cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install
')

REG(GSTBASE)

include(end.m4)
