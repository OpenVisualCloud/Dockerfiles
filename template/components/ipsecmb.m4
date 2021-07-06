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

DECLARE(`IPSECMB_VER',v1.0)

ifelse(OS_NAME,ubuntu,`
define(`IPSECMB_BUILD_DEPS',`git make ifelse(OS_VERSION,18.04,software-properties-common,gcc g++) ')
')

ifelse(OS_NAME,centos,`
define(`IPSECMB_BUILD_DEPS',`git make devtoolset-9')
')

define(`BUILD_IPSECMB',`
ifelse(OS_NAME:OS_VERSION,ubuntu:18.04,`dnl
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && apt-get install -y gcc-9 g++-9
')
ARG IPSECMB_REPO=https://github.com/intel/intel-ipsec-mb.git
RUN cd BUILD_HOME && \
    git clone -b IPSECMB_VER ${IPSECMB_REPO} && \
    cd intel-ipsec-mb && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifelse(OS_NAME:OS_VERSION,ubuntu:18.04,CC="gcc-9" CXX="g++-9" )CFLAGS="-Wl,-rpath=BUILD_PREFIX/ssl/lib" make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y ifelse(OS_NAME:OS_VERSION,centos:7,`) ') && \
    make install && \
    make install ifelse(OS_NAME,ubuntu,PREFIX=BUILD_DESTDIR\BUILD_PREFIX,PREFIX=BUILD_DESTDIR) 
')

REG(IPSECMB)

include(end.m4)dnl
