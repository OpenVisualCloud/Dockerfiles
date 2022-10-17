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

DECLARE(`QAT_CRYPTOMB_VER',ippcp_2021.6)

ifelse(OS_NAME,ubuntu,`
define(`QAT_CRYPTOMB_BUILD_DEPS',`wget ca-certificates ifdef(`BUILD_CMAKE',,cmake) make python ')
')

ifelse(OS_NAME,centos,`
define(`QAT_CRYPTOMB_BUILD_DEPS',`wget ifdef(`BUILD_CMAKE',,cmake3) make python devtoolset-9')
')

define(`BUILD_QAT_CRYPTOMB',`
ARG QAT_CRYPTOMB_REPO=https://github.com/intel/ipp-crypto/archive/QAT_CRYPTOMB_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${QAT_CRYPTOMB_REPO} | tar xz && \
    mkdir -p ipp-crypto-QAT_CRYPTOMB_VER/sources/ippcp/crypto_mb/build && \
    cd ipp-crypto-QAT_CRYPTOMB_VER/sources/ippcp/crypto_mb/build && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ') CFLAGS="-Wl,-rpath=BUILD_PREFIX/ssl/lib" ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) -DOPENSSL_INCLUDE_DIR=BUILD_PREFIX/ssl/include -DOPENSSL_LIBRARIES=BUILD_PREFIX/ssl/lib -DOPENSSL_ROOT_DIR=BUILD_PREFIX/ssl .. && \
    make -j8 ifelse(OS_NAME:OS_VERSION,centos:7,`) ') && \
    make install && \
    make install DESTDIR=BUILD_DESTDIR
')

REG(QAT_CRYPTOMB)

include(end.m4)dnl
