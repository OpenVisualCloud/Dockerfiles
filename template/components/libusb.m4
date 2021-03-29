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

DECLARE(`LIBUSB_VER',v1.0.22)

ifelse(OS_NAME,ubuntu,`
define(`LIBUSB_BUILD_DEPS',`wget make autoconf automake build-essential ca-certificates libtool libboost-filesystem1.65 libboost-thread1.65 libboost-program-options1.65 libjson-c-dev')

define(`LIBUSB_INSTALL_DEPS',`libboost-filesystem1.65-dev libboost-thread1.65-dev libboost-program-options1.65-dev libjson-c3')
')

define(`BUILD_LIBUSB',`
# build libusb
ARG LIBUSB_REPO=https://github.com/libusb/libusb/archive/LIBUSB_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBUSB_REPO} | tar xz && \
    cd libusb* && \
    ./autogen.sh enable_udev=no && \
    make -j$(nproc) && \
    cp ./libusb/.libs/libusb-1.0.so /lib/x86_64-linux-gnu/libusb-1.0.so.0

RUN mkdir -p BUILD_DESTDIR/lib/x86_64-linux-gnu	&& \
    cp /lib/x86_64-linux-gnu/libusb-1.0.so.0 BUILD_DESTDIR/lib/x86_64-linux-gnu/libusb-1.0.so.0
')

REG(LIBUSB)

include(end.m4)dnl
