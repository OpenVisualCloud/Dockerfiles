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
DECLARE(`GST_X265ENC',true)
DECLARE(`GST_LIBDE265DEC',true)

define(`GST_CURLUSESSL_BUILD',dnl
ifelse(GST_CURLUSESSL,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_OPENSSL',,openssl) libcurl4-gnutls-dev,
OS_NAME,centos,ifdef(`BUILD_OPENSSL',,openssl) libcurl-devel)'))dnl

define(`GST_CURLUSESSL_INSTALL',dnl
ifelse(GST_CURLUSESSL,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_OPENSSL',,openssl) libcurl3-gnutls,
OS_NAME,centos,ifdef(`BUILD_OPENSSL',,openssl))'))dnl

define(`GST_RTMP_BUILD',dnl
ifelse(GST_RTMP,true,`ifelse(
OS_NAME,ubuntu,librtmp-dev,
OS_NAME,centos,librtmp-devel)'))dnl

define(`GST_RTMP_INSTALL',dnl
ifelse(GST_RTMP,true,`ifelse(
OS_NAME,ubuntu,librtmp1,
OS_NAME,centos,librtmp)'))dnl

define(`GST_MJPEG_BUILD',dnl
ifelse(GST_MJPEG,true,`ifelse(
OS_NAME,ubuntu,mjpegtools,
OS_NAME,centos,mjpegtools)'))dnl

define(`GST_MJPEG_INSTALL',dnl
ifelse(GST_MJPEG,true,`ifelse(
OS_NAME,ubuntu,mjpegtools,
OS_NAME,centos,mjpegtools)'))dnl

define(`GST_X265ENC_BUILD',dnl
ifelse(GST_X265ENC,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBX265',,libx265-dev),
OS_NAME,centos,ifdef(`BUILD_LIBX265',,x265-devel))'))dnl

define(`GST_X265ENC_INSTALL',dnl
ifelse(GST_X265ENC,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBX265',,libx265-179),
OS_NAME,centos,ifdef(`BUILD_LIBX265',,x265))'))dnl

define(`GST_LIBDE265DEC_BUILD',dnl
ifelse(GST_LIBDE265DEC,true,`ifelse(
OS_NAME,ubuntu,libde265-dev,
OS_NAME,centos,libde265-devel)'))dnl

define(`GST_LIBDE265DEC_INSTALL',dnl
ifelse(GST_LIBDE265DEC,true,`ifelse(
OS_NAME,ubuntu,libde265-0,
OS_NAME,centos,libde265)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTBAD_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_CURLUSESSL_BUILD GST_RTMP_BUILD GST_MJPEG_BUILD GST_X265ENC_BUILD GST_LIBDE265DEC_BUILD')'
`define(`GSTBAD_INSTALL_DEPS',`libglib2.0-0 GST_CURLUSESSL_INSTALL GST_RTMP_INSTALL GST_MJPEG_INSTALL GST_X265ENC_INSTALL GST_LIBDE265DEC_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTBAD_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_CURLUSESSL_BUILD GST_RTMP_BUILD GST_MJPEG_BUILD GST_X265ENC_BUILD GST_LIBDE265DEC_BUILD')'
`define(`GSTBAD_INSTALL_DEPS',`glib2 GST_CURLUSESSL_INSTALL GST_RTMP_INSTALL GST_MJPEG_INSTALL GST_X265ENC_INSTALL GST_LIBDE265DEC_INSTALL')'
)

define(`BUILD_GSTBAD',
ARG GSTBAD_REPO=https://github.com/GStreamer/gst-plugins-bad/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTBAD_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-bad-GSTCORE_VER && \
  meson build \
    --prefix=BUILD_PREFIX \
    --libdir=BUILD_LIBDIR \
    --libexecdir=BUILD_LIBDIR \
    --buildtype=plain \
    -Ddoc=disabled \
    -Dexamples=disabled \
    -Dgtk_doc=disabled \
    -Dtests=disabled && \
  cd build && \
  ninja install && \
  DESTDIR=BUILD_DESTDIR ninja install
)

REG(GSTBAD)

include(end.m4)
