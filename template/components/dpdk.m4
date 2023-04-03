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

DECLARE(`DPDK_VER',v22.11)

ifelse(OS_NAME,ubuntu,`
define(`DPDK_BUILD_DEPS',`sudo git g++ wget meson kmod ffmpeg unzip python3 python3-pip pkg-config libnuma-dev libjson-c-dev libpcap-dev libgtest-dev libsdl2-dev libsdl2-ttf-dev libssl-dev python3-pyelftools ninja-build pciutils iproute2')
define(`DPDK_INSTALL_DEPS',`libnuma1 pciutils iproute2 libpcap0.8 libatomic1 kmod')
')

define(`BUILD_DPDK',`
# build DPDK
ARG DPDK_REPO=https://github.com/DPDK/dpdk.git
RUN cd BUILD_HOME && \
    git clone ${DPDK_REPO} && \
    cd dpdk && \
    git checkout DPDK_VER && \
    meson build --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    ninja -C build && \
    cd build && \
    ninja install && \
    pkg-config --cflags libdpdk && \
    pkg-config --libs libdpdk && \
    pkg-config --modversion libdpdk

')

REG(DPDK)

include(end.m4)dnl
