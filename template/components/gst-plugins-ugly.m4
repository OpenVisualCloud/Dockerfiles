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

dnl Optional libraries can set ON or OFF different plugins inside this ugly gst plugin.
dnl Default option is ON (true value), to disable it use the m4 feature "define" by setting `-D GST_*=false` value.
dnl For more information about optional libraries for this ugly gst plugin go to:
dnl https://github.com/GStreamer/gst-plugins-ugly/blob/master/REQUIREMENTS

dnl Dependency libraries in other templates can set whether build or runtime different dependencies in this template.
dnl To manage this please refer to them by using the `BUILD_*` m4 definition in a `ifdef` m4 conditional.

DECLARE(`GST_X264ENC',true)

define(`GST_X264ENC_BUILD',dnl
ifelse(GST_X264ENC,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBX264',,libx264-dev),
OS_NAME,centos,ifdef(`BUILD_LIBX264',,libx264-devel))'))dnl

define(`GST_X264ENC_INSTALL',dnl
ifelse(GST_X264ENC,true,`ifelse(
OS_NAME,ubuntu,ifdef(`BUILD_LIBX264',,libx264-155),
OS_NAME,centos,ifdef(`BUILD_LIBX264',,libx264-static))'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`GSTUGLY_BUILD_DEPS',`ca-certificates meson tar g++ wget pkg-config libglib2.0-dev flex bison GST_X264ENC_BUILD')'
`define(`GSTUGLY_INSTALL_DEPS',`libglib2.0-0 GST_X264ENC_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`GSTUGLY_BUILD_DEPS',`meson wget tar gcc-c++ glib2-devel bison flex GST_X264ENC_BUILD')'
`define(`GSTUGLY_INSTALL_DEPS',`glib2 GST_X264ENC_INSTALL')'
)

define(`BUILD_GSTUGLY',
ARG GSTUGLY_REPO=https://github.com/GStreamer/gst-plugins-ugly/archive/GSTCORE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTUGLY_REPO} | tar xz
RUN cd BUILD_HOME/gst-plugins-ugly-GSTCORE_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
)

REG(GSTUGLY)

include(end.m4)dnl
