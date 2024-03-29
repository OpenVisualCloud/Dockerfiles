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

include(gst-plugins-base.m4)

dnl Optional libraries can set ON or OFF different plugins inside this bad gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this bad gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-bad/blob/master/REQUIREMENTS

dnl Dependency libraries in other templates can set whether build or runtime different dependencies in this template.
dnl To manage this please refer to them by using the `BUILD_*` m4 definition in a `ifdef` m4 conditional.

DECLARE(`GST_CURLUSESSL',true)
DECLARE(`GST_RTMP',true)
DECLARE(`GST_MJPEG',true)
DECLARE(`GST_LIBDE265DEC',true)
DECLARE(`GST_RSVG',false)
DECLARE(`GST_FDKAAC',ifdef(`BUILD_LIBFDKAAC',true,false))

ifelse(OS_NAME,ubuntu,`
define(`GSTBAD_BUILD_DEPS',`ca-certificates ifdef(`BUILD_MESON',,meson) tar g++ wget pkg-config libglib2.0-dev flex bison gobject-introspection libgirepository1.0-dev ifelse(GST_CURLUSESSL,true,ifdef(`BUILD_OPENSSL',,openssl) libcurl4-gnutls-dev) ifelse(GST_RTMP,true,librtmp-dev) ifelse(GST_MJPEG,true,mjpegtools) ifelse(GST_LIBDE265DEC,true,libde265-dev) ifelse(GST_RSVG,true,librsvg2-dev) ifelse(GST_FDKAAC,true,ifdef(`BUILD_LIBFDKAAC',,libfdk-aac-dev))')

define(`GSTBAD_INSTALL_DEPS',`libglib2.0-0 ifelse(GST_CURLUSESSL,true,ifdef(`BUILD_OPENSSL',,openssl) libcurl3-gnutls) ifelse(GST_RTMP,true,librtmp1) ifelse(GST_MJPEG,true,mjpegtools) ifelse(GST_LIBDE265DEC,true,libde265-0) ifelse(GST_RSVG,true,librsvg2-2) ifelse(GST_FDKAAC,true,ifdef(`BUILD_LIBFDKAAC',,libfdk-aac1))')
')

ifelse(OS_NAME,centos,`
define(`GSTBAD_BUILD_DEPS',`ifdef(`BUILD_MESON',,meson) wget tar glib2-devel bison flex gobject-introspection-devel ifelse(GST_CURLUSESSL,true,ifdef(`BUILD_OPENSSL',,openssl) libcurl-devel) ifelse(GST_RTMP,true,librtmp-devel) ifelse(GST_MJPEG,true,mjpegtools) ifelse(GST_LIBDE265DEC,true,libde265-devel) ifelse(OS_VERSION,7,devtoolset-9) ifelse(GST_RSVG,true,librsvg2-devel)')

define(`GSTBAD_INSTALL_DEPS',`glib2 gobject-introspection ifelse(GST_CURLUSESSL,true,ifdef(`BUILD_OPENSSL',,openssl)) ifelse(GST_RTMP,true,librtmp) ifelse(GST_MJPEG,true,mjpegtools) ifelse(GST_LIBDE265DEC,true,libde265) ifelse(GST_RSVG,true,librsvg2)')
')

define(`BUILD_GSTBAD',`
# build gst-plugin-bad
ARG GSTBAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-GSTCORE_VER.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
    wget -O - ${GSTBAD_REPO} | tar xJ && \
    cd gst-plugins-bad-GSTCORE_VER && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')meson build \
      --prefix=BUILD_PREFIX \
      --libdir=BUILD_LIBDIR \
      --libexecdir=BUILD_LIBDIR \
      --buildtype=plain \
      -Ddoc=disabled \
      -Dexamples=disabled \
      -Dtests=disabled \
      -Dintrospection=enabled \
      -Dgpl=enabled \
      -Drtmp=ifelse(GST_RTMP,true,enabled,disabled) \
      -Dx265=ifdef(`BUILD_LIBX265',enabled,disabled) \
      -Drsvg=ifelse(GST_RSVG,true,enabled,disabled) \
      -Dfdkaac=ifelse(GST_FDKAAC,true,enabled,disabled) \
    && cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install ifelse(OS_NAME:OS_VERSION,centos:7,`)')
')

REG(GSTBAD)

include(end.m4)
