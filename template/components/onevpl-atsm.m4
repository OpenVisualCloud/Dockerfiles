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

DECLARE(`ONEVPL_GPU_VER',intel-onevpl-22.5.2)
DECLARE(`ONEVPL_GPU_SRC_REPO',https://github.com/oneapi-src/oneVPL-intel-gpu/archive/refs/tags/ONEVPL_GPU_VER.tar.gz)
DECLARE(`ONEVPL_GPU_BUILD_SAMPLES',no)

ifelse(OS_NAME,ubuntu,`
define(`ONEVPL_GPU_BUILD_DEPS',`ca-certificates gcc g++ make ifdef(`BUILD_CMAKE',,cmake) pkg-config wget')
')

ifelse(OS_NAME,centos,`
define(`ONEVPL_GPU_BUILD_DEPS',`ifdef(`BUILD_CMAKE',,cmake) gcc gcc-c++ make pkg-config wget ifdef(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_ONEVPL_GPU',`
# build onevpl runtime for GPU
ARG ONEVPL_GPU_REPO=ONEVPL_GPU_SRC_REPO
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
    wget -O - ${ONEVPL_GPU_REPO} | tar xz
RUN cd BUILD_HOME/oneVPL-intel-gpu-ONEVPL_GPU_VER && \
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR \
    -DBUILD_SAMPLES=MSDK_BUILD_SAMPLES \
    -DBUILD_TUTORIALS=OFF \
    .. && \
    make -j"$(nproc)" && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

REG(ONEVPL_GPU)

include(end.m4)dnl
