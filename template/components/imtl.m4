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

ifelse(OS_NAME,ubuntu,`
define(`IMTL_BUILD_DEPS',`sudo git g++ wget meson kmod ffmpeg unzip python3 python3-pip pkg-config libnuma-dev libjson-c-dev libpcap-dev libgtest-dev libsdl2-dev libsdl2-ttf-dev libssl-dev python3-pyelftools ninja-build pciutils iproute2')
define(`IMTL_INSTALL_DEPS',`libnuma1 pciutils iproute2 libpcap0.8 libatomic1 kmod libsdl2-2.0-0 libsdl2-ttf-2.0-0 libstdc++6')
')

define(`BUILD_IMTL',`
# build imtl
ARG DPDK_VERSION=22.11
ARG IMTL_VER=23.04
ARG DPDK_REPO=https://github.com/DPDK/dpdk.git
ARG IMTL_REPO=https://github.com/OpenVisualCloud/Media-Transport-Library/archive/refs/tags/v${IMTL_VER}.tar.gz
ARG DPDK_ST_KAHAWAI=BUILD_HOME/Media-Transport-Library-${IMTL_VER}
ARG LIB_BUILD_DIR=${DPDK_ST_KAHAWAI}/build
ARG APP_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/app
ARG TEST_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/tests
ARG PLUGINS_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/plugins
ARG LD_PRELOAD_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/ld_preload
ENV PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:BUILD_PREFIX/lib/pkgconfig
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:BUILD_PREFIX/lib
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd BUILD_HOME && \
    rm -rf dpdk && \
    git clone ${DPDK_REPO} && \
    wget -O - ${IMTL_REPO} | tar xz  && \
    cd dpdk && \
    git checkout v${DPDK_VERSION} && \
    git switch -c v${DPDK_VERSION} && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git am ${DPDK_ST_KAHAWAI}/patches/dpdk/${DPDK_VERSION}/*.patch && \
    meson build --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    ninja -C build && \
    cd build && \
    ninja install && \
    pkg-config --cflags libdpdk && \
    pkg-config --libs libdpdk && \
    pkg-config --modversion libdpdk && \
    cd ${DPDK_ST_KAHAWAI} && \
    meson ${LIB_BUILD_DIR} --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    cd ${LIB_BUILD_DIR} && \
    ninja && \
    ninja install && \
    cd ${DPDK_ST_KAHAWAI}/app && \
    meson ${APP_BUILD_DIR} --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    cd ${APP_BUILD_DIR} && \
    ninja && \
    cd ${DPDK_ST_KAHAWAI}/tests && \
    meson ${TEST_BUILD_DIR} --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    cd ${TEST_BUILD_DIR} && \
    ninja && \
    cd ${DPDK_ST_KAHAWAI}/plugins/ && \
    meson ${PLUGINS_BUILD_DIR} --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    cd ${PLUGINS_BUILD_DIR} && \
    ninja && \
    ninja install && \
    cd ${DPDK_ST_KAHAWAI}/ld_preload && \
    meson ${LD_PRELOAD_BUILD_DIR} --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
    cd ${LD_PRELOAD_BUILD_DIR} && \
    ninja && \
    ninja install && \
    mkdir -p BUILD_DESTDIR/home/imtl && \
    cp -r ${DPDK_ST_KAHAWAI}/config ${APP_BUILD_DIR} && \
    cp -r ${APP_BUILD_DIR} ${TEST_BUILD_DIR} BUILD_DESTDIR/home/imtl && \
    mkdir -p BUILD_DESTDIR/usr/local && \
    cp -r BUILD_PREFIX/bin BUILD_PREFIX/lib BUILD_DESTDIR/usr/local

')

REG(IMTL)

include(end.m4)dnl
