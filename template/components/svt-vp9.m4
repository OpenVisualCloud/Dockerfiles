dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2023, Intel Corporation
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

DECLARE(`SVT_VP9_VER',v0.3.0)

include(yasm.m4)

ifelse(OS_NAME,ubuntu,`
define(`SVT_VP9_BUILD_DEPS',`ca-certificates wget tar g++ make ifdef(`BUILD_CMAKE',,cmake) git')
')

ifelse(OS_NAME,centos,`
define(`SVT_VP9_BUILD_DEPS',`wget tar gcc-c++ make git ifdef(`BUILD_CMAKE',,cmake3) ifdef(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_SVT_VP9',`
# build svt vp9
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9
RUN cd BUILD_HOME && \
    git clone ${SVT_VP9_REPO} -b SVT_VP9_VER --depth 1 && \
    cd SVT-VP9/Build/linux && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')ifdef(`BUILD_CMAKE',cmake,ifelse(OS_NAME,centos,cmake3,cmake)) -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j "$(nproc)"ifelse(OS_NAME:OS_VERSION,centos:7,` )') && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`FFMPEG_PATCH_SVT_VP9',`dnl
RUN cd $1 && \
    patch -p1 < ../SVT-VP9/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-vp9.patch || true
')

REG(SVT_VP9)

include(end.m4)dnl
