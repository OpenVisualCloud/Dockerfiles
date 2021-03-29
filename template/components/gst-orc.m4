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

DECLARE(`GST_ORC_VER',0.4.32)

ifelse(OS_NAME,ubuntu,`
define(`GSTORC_BUILD_DEPS',`ca-certificates tar g++ wget ifdef(`BUILD_MESON',,meson)')
')

ifelse(OS_NAME,centos,`
define(`GSTORC_BUILD_DEPS',`wget tar gcc-c++ ifdef(`BUILD_MESON',,meson)')
')

define(`BUILD_GSTORC',`
# build gst-plugin-orc
ARG GSTORC_REPO=https://github.com/GStreamer/orc/archive/GST_ORC_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${GSTORC_REPO} | tar xz
RUN cd BUILD_HOME/orc-GST_ORC_VER && \
    meson build --libdir=BUILD_LIBDIR --libexecdir=BUILD_LIBDIR \
    --prefix=BUILD_PREFIX --buildtype=plain \
    -Dgtk_doc=disabled && \
    cd build && \
    ninja install && \
    DESTDIR=BUILD_DESTDIR ninja install
')

REG(GSTORC)

include(end.m4)dnl
