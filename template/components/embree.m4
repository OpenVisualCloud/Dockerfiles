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

DECLARE(`EMBREE_VER',df0b324)

ifelse(OS_NAME,ubuntu,`
define(`EMBREE_BUILD_DEPS',`ca-certificates wget g++ make cmake git libtbb-dev libgl1-mesa-dev')
define(`EMBREE_INSTALL_DEPS',`libtbb2')
')

ifelse(OS_NAME,centos,`
define(`EMBREE_BUILD_DEPS',`wget gcc-c++ make ifdef(`BUILD_CMAKE',,cmake) git tbb-devel mesa-libGL-devel')
define(`EMBREE_INSTALL_DEPS',`tbb')
')

define(`BUILD_EMBREE',`
# build EMBREE
ARG EMBREE_REPO=https://github.com/embree/embree.git
RUN cd BUILD_HOME && \
    git clone ${EMBREE_REPO} && \
    mkdir embree/build && \
    cd embree/build && \
    git checkout EMBREE_VER && \
    cmake .. -Wno-dev -DEMBREE_TUTORIALS=OFF && \
    make -j 8 && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

REG(EMBREE)

include(end.m4)dnl
