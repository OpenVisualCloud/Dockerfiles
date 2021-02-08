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

DECLARE(`OPENH264_VER',v1.7.4)

ifelse(OS_NAME,ubuntu,`
define(`OPENH264_BUILD_DEPS',`ca-certificates wget bzip2')
')

ifelse(OS_NAME,centos,`
define(`OPENH264_BUILD_DEPS',`wget bzip2')
')

define(`BUILD_OPENH264',`dnl
# Build OpenH264
ARG OPENH264_SRC_REPO=https://github.com/cisco/openh264/archive/patsubst(OPENH264_VER,`.[0-9]*$',`.0').tar.gz
ARG OPENH264_BIN_REPO=https://github.com/cisco/openh264/releases/download/patsubst(OPENH264_VER,`.[0-9]*$',`.0')/libopenh264-patsubst(OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0')-linux64.regexp(OPENH264_VER,`\([0-9]*\)$',`\1').so.bz2
RUN cd BUILD_HOME && \
    wget -O - ${OPENH264_SRC_REPO} | tar xz openh264-patsubst(OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0')/codec/api && \
    cd openh264-patsubst(OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0') && \
    (mkdir -p BUILD_PREFIX/include/openh264 && cp -r codec BUILD_PREFIX/include/openh264) && \
    (mkdir -p defn(`BUILD_DESTDIR',`BUILD_PREFIX')/include/openh264 && cp -r codec defn(`BUILD_DESTDIR',`BUILD_PREFIX')/include/openh264)

RUN cd BUILD_LIBDIR && \
    wget -O - ${OPENH264_BIN_REPO} | bunzip2 > libopenh264.so.regexp(OPENH264_VER,`\([0-9]*\)$',`\1') && \
    ln -s -v libopenh264.so.regexp(OPENH264_VER,`\([0-9]*\)$',`\1') libopenh264.so && \
    cd defn(`BUILD_DESTDIR',`BUILD_LIBDIR') && \
    cp -r BUILD_LIBDIR/libopenh264.so.regexp(OPENH264_VER,`\([0-9]*\)$',`\1') . && \
    ln -s -v libopenh264.so.regexp(OPENH264_VER,`\([0-9]*\)$',`\1') libopenh264.so
')

REG(OPENH264)

include(end.m4)dnl
