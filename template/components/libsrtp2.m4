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

DECLARE(`LIBSRTP2_VER',v2.3.0)

ifelse(OS_NAME,ubuntu,`
define(`LIBSRTP2_BUILD_DEPS',`ca-certificates wget gcc make pkg-config ifdef(`BUILD_OPENSSL',,libssl-dev)')
')

ifelse(OS_NAME,centos,`
define(`LIBSRTP2_BUILD_DEPS',`wget gcc make pkg-config ifdef(`BUILD_OPENSSL',,openssl-dev)')
')

define(`BUILD_LIBSRTP2',`
# build libsrtp2
ARG LIBSRTP2_REPO=https://github.com/cisco/libsrtp/archive/LIBSRTP2_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBSRTP2_REPO} | tar xz && \
    cd libsrtp-patsubst(LIBSRTP2_VER,v) && \
    CFLAGS="-fPIC`'ifdef(`BUILD_OPENSSL',` -Wl`,'-rpath=BUILD_PREFIX/ssl/lib')" ./configure --enable-openssl --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --with-openssl-dir=BUILD_PREFIX/ssl && \
    make -s V=0 -j $(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

ifelse(OS_NAME,ubuntu,`
define(`LIBSRTP2_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,libssl1.1)')
')

ifelse(OS_NAME,centos,`
define(`LIBSRTP2_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,openssl11)')
')

REG(LIBSRTP2)

include(end.m4)

