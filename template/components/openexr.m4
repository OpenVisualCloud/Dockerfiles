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

DECLARE(`OPENEXR_VER',0ac2ea3)

ifelse(OS_NAME,ubuntu,`
define(`OPENEXR_BUILD_DEPS',`ca-certificates g++ make ifdef(`BUILD_CMAKE',,cmake) git libtiff-dev zlib1g-dev libpng-dev libjpeg-dev ifelse(OS_VERSION,20.04,python2.7-dev libboost1.67-dev libboost-python1.67-dev libboost-filesystem1.67-dev libboost-thread1.67-dev,libboost-python-dev libboost-filesystem-dev libboost-thread-dev)')
define(`OPENEXR_INSTALL_DEPS',`libtiff-dev libpng16-16 ifelse(OS_VERSION,20.04,libboost-filesystem1.67-dev libboost-thread1.67-dev,libboost-filesystem-dev libboost-thread-dev)')
')

ifelse(OS_NAME,centos,`
define(`OPENEXR_BUILD_DEPS',`gcc-c++ make ifdef(`BUILD_CMAKE',,cmake) git libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel')
define(`OPENEXR_INSTALL_DEPS',`libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel')
')

define(`BUILD_OPENEXR',`
# build OpenEXR

ARG OpenEXR_REPO=https://github.com/openexr/openexr.git
RUN cd BUILD_HOME && \
    git clone ${OpenEXR_REPO} && \
    mkdir openexr/build && \
    cd openexr/build && \
    git reset --hard OPENEXR_VER && \
    cmake .. && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

REG(OPENEXR)

include(end.m4)dnl
