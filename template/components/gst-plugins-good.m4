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

dnl Optional libraries can set ON or OFF different plugins inside this good gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this good gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-good/blob/master/REQUIREMENTS

dnl Dependency libraries in other templates can set whether build or runtime different dependencies in this template.
dnl To manage this please refer to them by using the `BUILD_*` m4 definition in a `ifdef` m4 conditional.

DECLARE(`GST_XLIB',true)
DECLARE(`GST_GDKPIXBUF',true)
DECLARE(`GST_JPEG',true)
DECLARE(`GST_PNG',true)
DECLARE(`GST_MP4',true)
DECLARE(`GST_SOUP',true)
DECLARE(`GST_VPX',true)

define(`GST_XLIB_BUILD',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-dev libxv-dev libxt-dev,
OS_NAME,centos,libX11-devel libXv-devel libXt-devel)'))dnl

define(`GST_XLIB_INSTALL',dnl
ifelse(GST_XLIB,true,`ifelse(
OS_NAME,ubuntu,libx11-6 libxv1 libxt6,
OS_NAME,centos,libX11 libXv libXt)'))dnl

define(`GST_GDKPIXBUF_BUILD',dnl
ifelse(GST_GDKPIXBUF,true,`ifelse(
OS_NAME,ubuntu,libgdk-pixbuf2.0-dev,
OS_NAME,centos,gdk-pixbuf2-devel)'))dnl

define(`GST_GDKPIXBUF_INSTALL',dnl
ifelse(GST_GDKPIXBUF,true,`ifelse(
OS_NAME,ubuntu,libgdk-pixbuf2.0-0,
OS_NAME,centos,gdk-pixbuf2)'))dnl

define(`GST_JPEG_BUILD',dnl
ifelse(GST_JPEG,true,`ifelse(
OS_NAME,ubuntu,libjpeg-turbo8-dev,
OS_NAME,centos,libjpeg-turbo-devel)'))dnl

define(`GST_JPEG_INSTALL',dnl
ifelse(GST_JPEG,true,`ifelse(
OS_NAME,ubuntu,libjpeg-turbo8,
OS_NAME,centos,libjpeg-turbo)'))dnl

define(`GST_PNG_BUILD',dnl
ifelse(GST_PNG,true,`ifelse(
OS_NAME,ubuntu,libpng-dev,
OS_NAME,centos,libpng-devel)'))dnl

define(`GST_PNG_INSTALL',dnl
ifelse(GST_PNG,true,`ifelse(
OS_NAME,ubuntu,libpng16-16,
OS_NAME,centos,libpng)'))dnl

define(`GST_MP4_BUILD',dnl
ifelse(GST_MP4,true,`ifelse(
OS_NAME,ubuntu,zlib1g-dev,
OS_NAME,centos,zlib-devel)'))dnl

define(`GST_MP4_INSTALL',dnl
ifelse(GST_MP4,true,`ifelse(
OS_NAME,ubuntu,zlib1g,
OS_NAME,centos,zlib)'))dnl

define(`GST_SOUP_BUILD',dnl
ifelse(GST_SOUP,true,`ifelse(
OS_NAME,ubuntu,libsoup2.4-dev,
OS_NAME,centos,libsoup-devel)'))dnl

define(`GST_SOUP_INSTALL',dnl
ifelse(GST_SOUP,true,`ifelse(
OS_NAME,ubuntu,libsoup2.4-1,
OS_NAME,centos,libsoup)'))dnl

define(`GST_VPX_BUILD',dnl
ifelse(GST_VPX,true,`ifdef(`BUILD_LIBVPX',,ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBVPX',,libvpx-dev),
OS_NAME,centos,ifdef(`BUILD_LIBVPX',,libvpx-devel)))'))dnl

define(`GST_VPX_INSTALL',dnl
ifelse(GST_VPX,true,`ifdef(`BUILD_LIBVPX',,ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBVPX',,libvpx6),
OS_NAME,centos,ifdef(`BUILD_LIBVPX',,libvpx)))'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTGOOD_BUILD_DEPS',`git ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_XLIB_BUILD GST_GDKPIXBUF_BUILD GST_JPEG_BUILD GST_PNG_BUILD GST_MP4_BUILD GST_SOUP_BUILD GST_VPX_BUILD')'
`define(`GSTGOOD_INSTALL_DEPS',`libglib2.0-0 GST_XLIB_INSTALL GST_GDKPIXBUF_INSTALL GST_JPEG_INSTALL GST_PNG_INSTALL GST_MP4_INSTALL GST_SOUP_INSTALL GST_VPX_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTGOOD_BUILD_DEPS',`git meson wget tar gcc-c++ glib2-devel bison flex GST_XLIB_BUILD GST_GDKPIXBUF_BUILD GST_JPEG_BUILD GST_PNG_BUILD GST_MP4_BUILD GST_SOUP_BUILD GST_VPX_BUILD')'
`define(`GSTGOOD_INSTALL_DEPS',`glib2 GST_XLIB_INSTALL GST_GDKPIXBUF_INSTALL GST_JPEG_INSTALL GST_PNG_INSTALL GST_MP4_INSTALL GST_SOUP_INSTALL GST_VPX_INSTALL')'
)

define(`BUILD_GSTGOOD',
ARG GSTGOOD_REPO=https://github.com/GStreamer/gst-plugins-good/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTGOOD_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-good-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

REG(GSTGOOD)

include(end.m4)dnl
