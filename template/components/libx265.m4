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

include(yasm.m4)

DECLARE(`LIBX265_VER',3.3)

ifelse(OS_NAME,ubuntu,`
define(`LIBX265_BUILD_DEPS',`libnuma-dev ifdef(`BUILD_CMAKE',,cmake) make')
define(`LIBX265_INSTALL_DEPS',`libnuma1')
')

ifelse(OS_NAME,centos,`
define(`LIBX265_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake) make numactl-devel libpciaccess-devel')
define(`LIBX265_INSTALL_DEPS',`numactl-libs libpciaccess')
')

define(`BUILD_LIBX265',`
# build libx265
ARG LIBX265_REPO=https://github.com/videolan/x265/archive/LIBX265_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBX265_REPO} | tar xz && \
    cd x265-LIBX265_VER/build/linux && \
    cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DLIB_INSTALL_DIR=BUILD_LIBDIR ../../source && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

REG(LIBX265)

include(end.m4)dnl
