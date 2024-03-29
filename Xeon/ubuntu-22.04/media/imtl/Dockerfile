

# BSD 3-Clause License
#
# Copyright (c) 2023, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This file is automatically generated from .m4 template.
# To update, modify the template and regenerate.
FROM ubuntu:22.04 AS build


RUN mkdir -p /opt/build && mkdir -p /opt/dist

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo git g++ wget meson kmod ffmpeg unzip python3 python3-pip pkg-config libnuma-dev libjson-c-dev libpcap-dev libgtest-dev libsdl2-dev libsdl2-ttf-dev libssl-dev python3-pyelftools ninja-build pciutils iproute2 && \
  rm -rf /var/lib/apt/lists/*

# build DPDK
ARG DPDK_REPO=https://github.com/DPDK/dpdk.git
RUN cd /opt/build && \
    git clone ${DPDK_REPO} && \
    cd dpdk && \
    git checkout v22.11 && \
    meson build --prefix=/usr/local --libdir=/usr/local/lib && \
    ninja -C build && \
    cd build && \
    ninja install && \
    pkg-config --cflags libdpdk && \
    pkg-config --libs libdpdk && \
    pkg-config --modversion libdpdk


RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo git g++ wget meson kmod ffmpeg unzip python3 python3-pip pkg-config libnuma-dev libjson-c-dev libpcap-dev libgtest-dev libsdl2-dev libsdl2-ttf-dev libssl-dev python3-pyelftools ninja-build pciutils iproute2 && \
  rm -rf /var/lib/apt/lists/*

# build imtl
ARG DPDK_VERSION=22.11
ARG IMTL_VER=23.04
ARG DPDK_REPO=https://github.com/DPDK/dpdk.git
ARG IMTL_REPO=https://github.com/OpenVisualCloud/Media-Transport-Library/archive/refs/tags/v${IMTL_VER}.tar.gz
ARG DPDK_ST_KAHAWAI=/opt/build/Media-Transport-Library-${IMTL_VER}
ARG LIB_BUILD_DIR=${DPDK_ST_KAHAWAI}/build
ARG APP_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/app
ARG TEST_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/tests
ARG PLUGINS_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/plugins
ARG LD_PRELOAD_BUILD_DIR=${DPDK_ST_KAHAWAI}/build/ld_preload
ENV PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    rm -rf dpdk && \
    git clone ${DPDK_REPO} && \
    wget -O - ${IMTL_REPO} | tar xz  && \
    cd dpdk && \
    git checkout v${DPDK_VERSION} && \
    git switch -c v${DPDK_VERSION} && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git am ${DPDK_ST_KAHAWAI}/patches/dpdk/${DPDK_VERSION}/*.patch && \
    meson build --prefix=/usr/local --libdir=/usr/local/lib && \
    ninja -C build && \
    cd build && \
    ninja install && \
    pkg-config --cflags libdpdk && \
    pkg-config --libs libdpdk && \
    pkg-config --modversion libdpdk && \
    cd ${DPDK_ST_KAHAWAI} && \
    meson ${LIB_BUILD_DIR} --prefix=/usr/local --libdir=/usr/local/lib && \
    cd ${LIB_BUILD_DIR} && \
    ninja && \
    ninja install && \
    cd ${DPDK_ST_KAHAWAI}/app && \
    meson ${APP_BUILD_DIR} --prefix=/usr/local --libdir=/usr/local/lib && \
    cd ${APP_BUILD_DIR} && \
    ninja && \
    cd ${DPDK_ST_KAHAWAI}/tests && \
    meson ${TEST_BUILD_DIR} --prefix=/usr/local --libdir=/usr/local/lib && \
    cd ${TEST_BUILD_DIR} && \
    ninja && \
    cd ${DPDK_ST_KAHAWAI}/plugins/ && \
    meson ${PLUGINS_BUILD_DIR} --prefix=/usr/local --libdir=/usr/local/lib && \
    cd ${PLUGINS_BUILD_DIR} && \
    ninja && \
    ninja install && \
    cd ${DPDK_ST_KAHAWAI}/ld_preload && \
    meson ${LD_PRELOAD_BUILD_DIR} --prefix=/usr/local --libdir=/usr/local/lib && \
    cd ${LD_PRELOAD_BUILD_DIR} && \
    ninja && \
    ninja install && \
    mkdir -p /opt/dist/home/imtl && \
    cp -r ${DPDK_ST_KAHAWAI}/config ${APP_BUILD_DIR} && \
    cp -r ${APP_BUILD_DIR} ${TEST_BUILD_DIR} /opt/dist/home/imtl && \
    mkdir -p /opt/dist/usr/local && \
    cp -r /usr/local/bin /usr/local/lib /opt/dist/usr/local


# cleanup
RUN rm -rf /opt/dist/usr/local/include && \
    rm -rf /opt/dist/usr/local/lib/pkgconfig && \
    find /opt/dist -name "*.a" -exec rm -f {} \; || echo ""
RUN rm -rf /opt/dist/usr/local/share/doc /opt/dist/usr/local/share/gtk-doc
RUN rm -rf /opt/dist/usr/local/share/man
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1

FROM ubuntu:22.04
LABEL Description="This is the base image for IMTL ubuntu 22.04"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
RUN apt-get update && apt-get upgrade -y systemd
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libnuma1 pciutils iproute2 libpcap0.8 libatomic1 kmod libsdl2-2.0-0 libsdl2-ttf-2.0-0 libstdc++6  && \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/dist /
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/all-libs.conf && ldconfig

HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1