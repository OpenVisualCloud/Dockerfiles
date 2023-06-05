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

include(media-delivery.m4)

DECLARE(`ONEVPL_DISP_VER',v2022.2.0)
DECLARE(`ONEVPL_DISP_VER_TRUNC',2022.2.0)
DECLARE(`ONEVPL_DISP_SRC_REPO',https://github.com/oneapi-src/oneVPL/archive/refs/tags/ONEVPL_DISP_VER.tar.gz)
DECLARE(`ONEVPL_DISP_BUILD_SAMPLES',no)

ifelse(OS_NAME,ubuntu,`
define(`ONEVPL_DISP_BUILD_DEPS',`ca-certificates gcc g++ make git ifdef(`BUILD_CMAKE',,cmake) patch')
')

define(`BUILD_ONEVPL_DISP',`
# build onevpl dispatcher
ARG ONEVPL_DISP_REPO=ONEVPL_DISP_SRC_REPO
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
    wget -O - ${ONEVPL_DISP_REPO} | tar xz 
RUN cd BUILD_HOME/oneVPL-ONEVPL_DISP_VER_TRUNC && \
    cp /opt/build/media-delivery/patches/libvpl2/* . && \
    { set -e; \
    for patch_file in $(find -iname "*.patch" | sort -n); do \
    echo "Applying: ${patch_file}"; \
    patch -p1 < ${patch_file}; \
    done; } && \
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

define(`INSTALL_ONEVPL_DISP',`
# Define ONEVPL lib dir
ENV ONEVPL_SEARCH_PATH=BUILD_LIBDIR
')


REG(ONEVPL_DISP)

include(end.m4)dnl
