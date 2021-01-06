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

include(yasm.m4)

DECLARE(`SVT_AV1_VER',v0.8.5)

include(yasm.m4)

ifelse(OS_NAME,ubuntu,dnl
`define(`SVT_AV1_BUILD_DEPS',`ca-certificates wget tar g++ make cmake git')'
)

ifelse(OS_NAME,centos,dnl
`define(`SVT_AV1_BUILD_DEPS',`wget tar gcc-c++ make git cmake3')'
)

define(`BUILD_SVT_AV1',
ARG SVT_AV1_REPO=https://github.com/AOMediaCodec/SVT-AV1
RUN cd BUILD_HOME && \
    git clone ${SVT_AV1_REPO} -b SVT_AV1_VER --depth 1 && \
    cd SVT-AV1/Build/linux && \
    ifelse(OS_NAME,centos,cmake3,cmake) -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j $(nproc) && \
    sed -i 's/SvtAv1dec/SvtAv1Dec/' SvtAv1Dec.pc && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
)

define(`FFMPEG_PATCH_SVT_AV1_VER',0.8.4)
define(`FFMPEG_PATCH_SVT_AV1',`
ARG FFMPEG_PATCH_SVT_AV1_REPO=https://github.com/AOMediaCodec/SVT-AV1/archive/v`'FFMPEG_PATCH_SVT_AV1_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${FFMPEG_PATCH_SVT_AV1_REPO} | tar xz && \
    cd $1 && \
    patch -p1 < ../SVT-AV1-FFMPEG_PATCH_SVT_AV1_VER/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1.patch || true
')

REG(SVT_AV1)

include(end.m4)dnl
