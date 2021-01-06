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

DECLARE(`YASM_VER',1.3.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`YASM_BUILD_DEPS',`ca-certificates wget tar g++ make')'
)

ifelse(OS_NAME,centos,dnl
`define(`YASM_BUILD_DEPS',`wget tar gcc-c++ make')'
)

define(`BUILD_YASM',
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-YASM_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${YASM_REPO} | tar xz
RUN cd BUILD_HOME/yasm-YASM_VER && \
    # TODO remove the line below whether no other component inside this project requires it.
    # `sed -i "s/) ytasm.*/)/" Makefile.in' && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    make -j $(nproc) && \
    make install
)

REG(YASM)

include(end.m4)dnl
