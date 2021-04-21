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

DECLARE(`LIBNICE_VER',0.1.4)

ifelse(OS_NAME,ubuntu,`
define(`LIBNICE_BUILD_DEPS',`ca-certificates wget ifdef(`BUILD_CMAKE',,cmake) make gcc libglib2.0-dev patch')
')

ifelse(OS_NAME,centos,`
define(`LIBNICE_BUILD_DEPS',`wget ifdef(`BUILD_CMAKE',,cmake) make gcc libglib2.0-devel patch')
')

define(`BUILD_LIBNICE',`
# build libnice
ARG LIBNICE_REPO=http://nice.freedesktop.org/releases/libnice-LIBNICE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBNICE_REPO} | tar xz

ifdef(`LIBNICE_PATCH_VER',`
ARG LIBNICE_PATCH_REPO=https://github.com/open-webrtc-toolkit/owt-server/archive/v`'LIBNICE_PATCH_VER.tar.gz

RUN cd BUILD_HOME/libnice-LIBNICE_VER && \
    wget -O - ${LIBNICE_PATCH_REPO} | tar xz && \
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-agentlock.patch && \
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-agentlock-plus.patch && \
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-removecandidate.patch && \
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-keepalive.patch && \
ifelse(OWT_360,false,`dnl
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-startcheck.patch && \
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-closelock.patch',`dnl
    patch -p1 < owt-server-LIBNICE_PATCH_VER/scripts/patches/libnice014-startcheck.patch
')
')

RUN cd BUILD_HOME/libnice-LIBNICE_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    make -j$(nproc) -s V=0 && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

REG(LIBNICE)

include(end.m4)dnl
