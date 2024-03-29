
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
FROM ubuntu:20.04 AS build


RUN mkdir -p /opt/build && mkdir -p /opt/dist

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget make autoconf automake g++ && \
  rm -rf /var/lib/apt/lists/*

# build libogg
ARG OGG_VER=1.3.5
ARG LIBOGG_REPO=https://github.com/xiph/ogg/releases/download/v${OGG_VER}/libogg-1.3.5.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN cd /opt/build && \
    wget -O - ${LIBOGG_REPO} | tar xz && \
    cd libogg-1.3.5 && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget make autoconf automake && \
  rm -rf /var/lib/apt/lists/*

# build libvorbis
ARG VORBIS_VER=1.3.7
ARG LIBVORBIS_REPO=https://github.com/xiph/vorbis/releases/download/v${VORBIS_VER}/libvorbis-1.3.7.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${LIBVORBIS_REPO} | tar xz && \
    cd libvorbis-1.3.7 && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget g++ autoconf libtool autotools-dev automake make && \
  rm -rf /var/lib/apt/lists/*

# build libfdkaac
ARG LIBFDKAAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/v2.0.2.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${LIBFDKAAC_REPO} | tar xz && \
    cd fdk-aac-2.0.2 && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget autoconf libtool make && \
  rm -rf /var/lib/apt/lists/*

# build libopus
ARG LIBOPUS_REPO=https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${LIBOPUS_REPO} | tar xz && \
    cd opus-1.3.1 && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget tar g++ make bzip2 && \
  rm -rf /var/lib/apt/lists/*

# build nasm
#ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/NASM_VER/nasm-NASM_VER.tar.bz2
# TODO: Revert to NASM repo, this is temp fix is nasm repo certificate expired temporarily

ARG NASM_REPO=https://github.com/OpenVisualCloud/Dockerfiles-Resources/raw/master/nasm-2.15.05.tar.bz2
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${NASM_REPO} | tar xj && \
    cd nasm-2.15.05 && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib && \
     make -j"$(nproc)" && \
     make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git cmake make autoconf && \
  rm -rf /var/lib/apt/lists/*

# build libvpx
ARG LIBVPX_REPO=https://chromium.googlesource.com/webm/libvpx.git
RUN cd /opt/build && \
    git clone ${LIBVPX_REPO} -b v1.12.0 --depth 1 && \
    cd libvpx && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git cmake make && \
  rm -rf /var/lib/apt/lists/*

# build libaom
ARG LIBAOM_REPO=https://aomedia.googlesource.com/aom
RUN cd /opt/build && \
    git clone ${LIBAOM_REPO} -b v3.4.0 --depth 1 && \
    cd aom/build && \
    cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib .. && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3-pip ninja-build python3-setuptools && \
  rm -rf /var/lib/apt/lists/*

# build meson
ARG MESON_REPO=https://github.com/mesonbuild/meson
RUN git clone ${MESON_REPO} && \
    cd meson && \
    git checkout 0.63.0 && \
    python3 setup.py install;

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget pkg-config && \
  rm -rf /var/lib/apt/lists/*

# build dav1d
ARG DAV1D_REPO=https://code.videolan.org/videolan/dav1d/-/archive/0.9.2/dav1d-0.9.2.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
  wget -O - ${DAV1D_REPO} | tar xz
RUN cd /opt/build/dav1d-0.9.2 && \
  meson build --prefix=/usr/local --libdir /usr/local/lib --buildtype=plain && \
  cd build && \
  ninja install && \
  DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget tar g++ make && \
  rm -rf /var/lib/apt/lists/*

# build yasm
# ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-YASM_VER.tar.gz
# At the time of 21.6 Release, yasm official site above had certificate problem, hence pulling from Dockerfiles-Resources.
ARG YASM_REPO=https://github.com/OpenVisualCloud/Dockerfiles-Resources/raw/master/yasm-1.3.0.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN cd /opt/build && \
    wget -O - ${YASM_REPO} | tar xz
RUN cd /opt/build/yasm-1.3.0 && \
    # TODO remove the line below whether no other component inside this project requires it.
    # `sed -i "s/) ytasm.*/)/" Makefile.in' && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib && \
    make -j "$(nproc)" && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget tar g++ make cmake git && \
  rm -rf /var/lib/apt/lists/*

# build svt-hevc
ARG SVT_HEVC_REPO=https://github.com/OpenVisualCloud/SVT-HEVC
RUN cd /opt/build && \
    git clone -b v1.5.1 --depth 1 ${SVT_HEVC_REPO}
RUN cd /opt/build/SVT-HEVC/Build/linux && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j "$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget tar g++ make cmake git && \
  rm -rf /var/lib/apt/lists/*

# build svt av1
ARG SVT_AV1_REPO=https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.3.0/SVT-AV1-v1.3.0.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${SVT_AV1_REPO} | tar zx && \
    mv SVT-AV1-v1.3.0 SVT-AV1 && \
    cd SVT-AV1/Build/linux && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j "$(nproc)" && \
    sed -i "s/SvtAv1dec/SvtAv1Dec/" SvtAv1Dec.pc && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates wget tar g++ make cmake git && \
  rm -rf /var/lib/apt/lists/*

# build svt vp9
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9
RUN cd /opt/build && \
    git clone ${SVT_VP9_REPO} -b v0.3.0 --depth 1 && \
    cd SVT-VP9/Build/linux && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j "$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates gpg-agent software-properties-common wget && \
  rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal main" | tee /etc/apt/sources.list.d/intel.gpu.focal.list

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-opencl-icd libvpl2 intel-level-zero-gpu level-zero-dev intel-media-va-driver-non-free && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates cmake gcc g++ make wget python3-numpy ccache libeigen3-dev && \
  rm -rf /var/lib/apt/lists/*

# build opencv
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/4.5.3-openvino-2021.4.2.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
  wget -O - ${OPENCV_REPO} | tar xz
# TODO: file a bug against opencv since they do not accept full libdir
RUN cd /opt/build/opencv-4.5.3-openvino-2021.4.2 && mkdir build && cd build && \
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_OPENJPEG=OFF \
    -DWITH_JASPER=OFF \
    .. && \
  make -j "$(nproc)" && \
  make install DESTDIR=/opt/dist && \
  make install 

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates cmake gcc g++ git libboost-all-dev libgtk2.0-dev libgtk-3-dev libtool libusb-1.0-0-dev make xz-utils libnuma-dev ocl-icd-opencl-dev opencl-headers && \
  rm -rf /var/lib/apt/lists/*

# build dldt
ARG DLDT_REPO=https://github.com/openvinotoolkit/openvino.git
RUN git clone -b 2022.2.0 --depth 1 ${DLDT_REPO} /opt/build/openvino && \
  cd /opt/build/openvino && \
  git submodule update --init --recursive

RUN cd /opt/build/openvino && \
  mkdir build && cd build && \
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local/openvino \
    -DENABLE_CPPLINT=OFF \
    -DDENABLE_INTEL_GNA=OFF \
    -DENABLE_INTEL_MYRIAD_COMMON=OFF \
    -DENABLE_INTEL_MYRIAD=OFF \
    -DENABLE_ONEDNN_FOR_GPU=ON \
    -DENABLE_VPU=OFF \
    -DENABLE_OPENCV=OFF \
    -DENABLE_MKL_DNN=ON \
    -DENABLE_CLDNN=ON \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_GAPI_TESTS=OFF \
    -DENABLE_BEH_TESTS=OFF \
    -DENABLE_FUNCTIONAL_TESTS=OFF \
    -DENABLE_OV_CORE_UNIT_TESTS=OFF \
    -DENABLE_OV_CORE_BACKEND_UNIT_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DTREAT_WARNING_AS_ERROR=OFF \
    .. && \
  make -j "$(nproc)" && \
  make install && \
  make install DESTDIR=/opt/dist 


ARG OPENVINO_INSTALL_DIR=/usr/local/openvino
ARG IE_INSTALL_DIR=${OPENVINO_INSTALL_DIR}/runtime/

ENV InferenceEngine_DIR=${IE_INSTALL_DIR}/cmake
ENV OpenVINO_DIR=${IE_INSTALL_DIR}/cmake
ENV TBB_DIR=${IE_INSTALL_DIR}/3rdparty/tbb/cmake
ENV ngraph_DIR=${IE_INSTALL_DIR}/cmake



ARG LIBJSONC_REPO=https://github.com/json-c/json-c/archive/json-c-0.16-20220414.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${LIBJSONC_REPO} | tar xz && \
    cd json-c-json-c-0.16-20220414 && mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib .. && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install



ARG KAFKA_VER=1.9.2
ARG LIBRDKAFKA_REPO=https://github.com/edenhill/librdkafka/archive/v${KAFKA_VER}.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${LIBRDKAFKA_REPO} | tar xz && \
    cd librdkafka-1.9.2 && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib && \
    make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget pkg-config libglib2.0-dev flex bison gobject-introspection libgirepository1.0-dev python3-dev && \
  rm -rf /var/lib/apt/lists/*

# build gst-core
ARG GSTCORE_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${GSTCORE_REPO} | tar xJ
RUN cd /opt/build/gstreamer-1.20.3 && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    --prefix=/usr/local --buildtype=plain \
    -Dexamples=disabled \
    -Dtests=disabled \
    -Ddoc=disabled \
    -Dintrospection=enabled && \
    cd build && \
    ninja install && \
    DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ gobjc wget pkg-config libglib2.0-dev flex bison gobject-introspection libgirepository1.0-dev libx11-dev libxv-dev libxt-dev libasound2-dev libpango1.0-dev libtheora-dev libvisual-0.4-dev libgl1-mesa-dev libx11-xcb-dev && \
  rm -rf /var/lib/apt/lists/*

# build gst-plugin-base
ARG GSTBASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
  wget -O - ${GSTBASE_REPO} | tar xJ
RUN cd /opt/build/gst-plugins-base-1.20.3 && \
  meson build \
    --prefix=/usr/local \
    --libdir=/usr/local/lib \
    --libexecdir=/usr/local/lib \
    --buildtype=plain \
    -Dexamples=disabled \
    -Dtests=disabled \
    -Ddoc=disabled \
    -Dintrospection=enabled \
    -Dalsa=enabled \
    -Dpango=enabled \
    -Dtheora=enabled \
    -Dlibvisual=enabled \
    -Dgl=enabled \
  && cd build && \
  ninja install && \
  DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git ca-certificates tar g++ wget pkg-config libglib2.0-dev flex bison libx11-dev libxv-dev libxt-dev libgdk-pixbuf2.0-dev libjpeg-turbo8-dev libpng-dev zlib1g-dev libsoup2.4-dev  && \
  rm -rf /var/lib/apt/lists/*

# build gst-plugin-good
ARG GSTGOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${GSTGOOD_REPO} | tar xJ
RUN cd /opt/build/gst-plugins-good-1.20.3 && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    --prefix=/usr/local --buildtype=plain \
    -Dexamples=disabled \
    -Dtests=disabled \
    -Ddoc=disabled \
    -Dgdk-pixbuf=enabled \
    -Djpeg=enabled \
    -Dpng=enabled \
    -Disomp4=enabled \
    -Dsoup=enabled \
    -Dvpx=enabled \
    && cd build && \
    ninja install && \
    DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget pkg-config libglib2.0-dev flex bison gobject-introspection libgirepository1.0-dev openssl libcurl4-gnutls-dev librtmp-dev mjpegtools libde265-dev  && \
  rm -rf /var/lib/apt/lists/*

# build gst-plugin-bad
ARG GSTBAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${GSTBAD_REPO} | tar xJ && \
    cd gst-plugins-bad-1.20.3 && \
    meson build \
      --prefix=/usr/local \
      --libdir=/usr/local/lib \
      --libexecdir=/usr/local/lib \
      --buildtype=plain \
      -Ddoc=disabled \
      -Dexamples=disabled \
      -Dtests=disabled \
      -Dintrospection=enabled \
      -Dgpl=enabled \
      -Drtmp=enabled \
      -Dx265=disabled \
      -Drsvg=disabled \
      -Dfdkaac=enabled \
    && cd build && \
    ninja install && \
    DESTDIR=/opt/dist ninja install 

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget pkg-config libglib2.0-dev flex bison && \
  rm -rf /var/lib/apt/lists/*

# build gst-plugin-ugly
ARG GSTUGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${GSTUGLY_REPO} | tar xJ
RUN cd /opt/build/gst-plugins-ugly-1.20.3 && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    --prefix=/usr/local --buildtype=plain \
    -Ddoc=disabled \
    -Dgpl=enabled \
    -Dx264=disabled \
    && cd build && \
    ninja install && \
    DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget pkg-config libdrm-dev libglib2.0-dev libudev-dev flex bison libva-dev && \
  rm -rf /var/lib/apt/lists/*

# patch gst-vaapi with gst-video-analytics patch
ARG GST_PLUGIN_VAAPI_PATCH_VER=ec2748da5b577bbf510525f57eabde6c58efd589
ARG GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS=https://github.com/dlstreamer/dlstreamer

# build gst-plugin-vaapi
ARG GSTVAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
  wget -O - ${GSTVAAPI_REPO} | tar xJ

RUN cd /opt/build/gstreamer-vaapi-1.20.3 && \
  git clone ${GST_PLUGIN_VAAPI_REPO_VIDEO_ANALYTICS} && \
  cd dlstreamer && git checkout ${GST_PLUGIN_VAAPI_PATCH_VER} && \
  cd .. && \
  git apply dlstreamer/patches/gstreamer-vaapi/*.patch && \
  rm -fr dlstreamer

RUN cd /opt/build/gstreamer-vaapi-1.20.3 && \
  meson build \
    --prefix=/usr/local \
    --libdir=/usr/local/lib \
    --libexecdir=/usr/local/lib \
    --buildtype=release \
    -Dexamples=disabled \
    -Dtests=disabled && \
  cd build && \
  ninja install && \
  DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget  && \
  rm -rf /var/lib/apt/lists/*

RUN cd /opt/build/SVT-HEVC/gstreamer-plugin && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    -Dprefix=/usr/local --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=/opt/dist ninja install
RUN cd /opt/build/SVT-AV1/gstreamer-plugin && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    -Dprefix=/usr/local --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=/opt/dist ninja install
RUN cd /opt/build/SVT-VP9/gstreamer-plugin && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    -Dprefix=/usr/local --buildtype=plain && \
    cd build && ninja install && \
    DESTDIR=/opt/dist ninja install

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget make libssl-dev uuid-dev && \
  rm -rf /var/lib/apt/lists/*

# build libpahomqtt
ARG PAHO_VER=1.3.10
ARG LIBPAHO_REPO=https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_VER}.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
  wget -O - ${LIBPAHO_REPO} | tar -xz
RUN cd /opt/build/paho.mqtt.c-1.3.10 && \
  make	&& \
  make install

#Copy and link in runtime layer
RUN cd /opt/build/paho.mqtt.c-1.3.10 && \
  cp build/output/libpaho-mqtt3c.so.1.3 /opt/dist//usr/local/lib && 	\
  cp build/output/libpaho-mqtt3cs.so.1.3 /opt/dist//usr/local/lib &&   \
  cp build/output/libpaho-mqtt3a.so.1.3 /opt/dist//usr/local/lib &&   \
  cp build/output/libpaho-mqtt3as.so.1.3 /opt/dist//usr/local/lib &&   \
  cp build/output/paho_c_version /opt/dist/usr/local/bin/ && \
  cp build/output/samples/paho_c_pub /opt/dist/usr/local/bin/ && \
  cp build/output/samples/paho_c_sub /opt/dist/usr/local/bin/ && \
  cp build/output/samples/paho_cs_pub /opt/dist/usr/local/bin/ && \
  cp build/output/samples/paho_cs_sub /opt/dist/usr/local/bin/ && \
  chmod 644 /opt/dist//usr/local/lib/libpaho-mqtt3c.so.1.3 && \
  chmod 644 /opt/dist//usr/local/lib/libpaho-mqtt3cs.so.1.3 && \
  chmod 644 /opt/dist//usr/local/lib/libpaho-mqtt3a.so.1.3 && \
  chmod 644 /opt/dist//usr/local/lib/libpaho-mqtt3as.so.1.3 && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3c.so.1.3 /opt/dist//usr/local/lib/libpaho-mqtt3c.so.1 && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3cs.so.1.3 /opt/dist//usr/local/lib/libpaho-mqtt3cs.so.1 && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3a.so.1.3 /opt/dist//usr/local/lib/libpaho-mqtt3a.so.1 && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3as.so.1.3 /opt/dist//usr/local/lib/libpaho-mqtt3as.so.1 && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3c.so.1 /opt/dist//usr/local/lib/libpaho-mqtt3c.so && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3cs.so.1 /opt/dist//usr/local/lib/libpaho-mqtt3cs.so && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3a.so.1 /opt/dist//usr/local/lib/libpaho-mqtt3a.so && \
  ln /opt/dist//usr/local/lib/libpaho-mqtt3as.so.1 /opt/dist//usr/local/lib/libpaho-mqtt3as.so && \
  cp src/MQTTAsync.h /opt/dist/usr/local/include/ && \
  cp src/MQTTClient.h /opt/dist/usr/local/include/ && \
  cp src/MQTTClientPersistence.h /opt/dist/usr/local/include/ && \
  cp src/MQTTProperties.h /opt/dist/usr/local/include/ && \
  cp src/MQTTReasonCodes.h /opt/dist/usr/local/include/ && \
  cp src/MQTTSubscribeOpts.h /opt/dist/usr/local/include/; 

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cmake git ocl-icd-opencl-dev opencl-headers pkg-config libpython3-dev python-gi-dev ca-certificates libva-dev curl gnupg2 software-properties-common && \
  rm -rf /var/lib/apt/lists/*

# build gst-plugin-gva
# formerly https://github.com/opencv/gst-video-analytics
ARG GVA_REPO=https://github.com/dlstreamer/dlstreamer
ENV LIBRARY_PATH=/usr/local/lib
RUN git clone -b master $GVA_REPO /opt/build/gst-video-analytics && \
    cd /opt/build/gst-video-analytics && \
    git checkout ec2748da5b577bbf510525f57eabde6c58efd589 && \
    git submodule update --init && \
    mkdir -p build && cd build && \
    cmake \
    -DVERSION_PATCH="$(git rev-list --count --first-parent HEAD)" \
    -DGIT_INFO=git_"$(git rev-parse --short HEAD)" \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_PAHO_INSTALLATION=ON \
    -DENABLE_RDKAFKA_INSTALLATION=ON \
    -DENABLE_VAAPI=ON \
    -DENABLE_AUDIO_INFERENCE_ELEMENTS=ON \
    -DTREAT_WARNING_AS_ERROR=OFF \
    .. \
    && make -j "$(nproc)" \
    && make install \
    && make install DESTDIR=/opt/dist 

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/gstreamer-1.0/:/usr/local/lib/

RUN cp -r  /opt/build/gst-video-analytics/build/intel64/Release/lib/* /usr/local/lib/gstreamer-1.0/.
RUN cp -r  /opt/build/gst-video-analytics/build/intel64/Release/lib/* /opt/dist//usr/local/lib/gstreamer-1.0/.
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/lib/gstreamer-1.0/

RUN mkdir -p /opt/intel/dl_streamer/python && \
    cp -r /opt/build/gst-video-analytics/python/* /opt/intel/dl_streamer/python

ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
RUN mkdir -p /opt/dist/opt/intel/dl_streamer/python && \
    cp -r /opt/build/gst-video-analytics/python/* /opt/dist/opt/intel/dl_streamer/python

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tar g++ wget gtk-doc-tools uuid-dev python-gi-dev python3-dev libtool-bin libpython3-dev libpython3-stdlib libpython3-all-dev  && \
  rm -rf /var/lib/apt/lists/*
ARG GSTPYTHON_REPO=https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.3.tar.xz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cd /opt/build && \
    wget -O - ${GSTPYTHON_REPO} | tar xJ
RUN cd /opt/build/gst-python-1.20.3 && \
#WORKAROUND: https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/30/diffs
sed -i "s/.*python\.dependency.*/pythonver \= python\.language_version\(\)\npython_dep \= dependency\(\'python-\@0\@-embed\'\.format\(pythonver\)\, version\: \'\>\=3\'\, required\: false\)\nif not python_dep\.found\(\)\n\tpython_dep \= python\.dependency\(required \: true\)\nendif/g" meson.build && \
    meson build --libdir=/usr/local/lib --libexecdir=/usr/local/lib \
    --prefix=/usr/local --buildtype=plain \
    -Dpython=/usr/bin/python3 -Dlibpython-dir=/usr/lib/x86_64-linux-gnu/  \
    -Dpygi-overrides-dir=/usr/lib/python3/dist-packages/gi/overrides && \
    cd build && \
    ninja install && \
    DESTDIR=/opt/dist ninja install


RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential ca-certificates wget patch git libv4l-dev libass-dev  && \
  rm -rf /var/lib/apt/lists/*

# build ffmpeg
#ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/FFMPEG_VER.tar.gz
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg
RUN cd /opt/build && \
    git clone ${FFMPEG_REPO} && \
    cd FFmpeg && \
    git checkout f6a36c7

#ifdef(`BUILD_SVT_HEVC',`FFMPEG_PATCH_SVT_HEVC(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl
RUN cd /opt/build/FFmpeg && \
    patch -p1 < /opt/build/SVT-HEVC/ffmpeg_plugin/n4.4-0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch || true
#ifdef(`BUILD_LIBVA2',`FFMPEG_PATCH_VAAPI(BUILD_HOME/FFmpeg-FFMPEG_VER)')dnl


ARG FFMPEG_1TN_PATCH_REPO=https://github.com/spawlows/FFmpeg/commit/6e747101f5fc0c4fb56a178c8ba24fcee4917139.patch
#RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
RUN cd /opt/build/FFmpeg && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1;

#RUN cd BUILD_HOME/FFmpeg-FFMPEG_VER && \
RUN cd /opt/build/FFmpeg && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib --enable-shared --disable-static --disable-doc --disable-htmlpages \
    --disable-manpages --disable-podpages --disable-txtpages \
    --extra-cflags=-w     --enable-nonfree     --enable-libass     --enable-libfreetype     --disable-xlib --disable-sdl2     --disable-hwaccels         --disable-vaapi     --enable-libv4l2 --enable-indev=v4l2         --enable-libfdk-aac     --enable-libopus     --enable-libvpx     --enable-libvorbis             --enable-libsvtav1         --enable-libaom         --enable-libdav1d         && make -j"$(nproc)" && \
    make install DESTDIR=/opt/dist && \
    make install

# cleanup
RUN rm -rf /opt/dist/usr/local/share/doc /opt/dist/usr/local/share/gtk-doc
RUN rm -rf /opt/dist/usr/local/share/man
RUN rm -rf /opt/dist/usr/local/openvino/inference-engine/external/tbb/doc
HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1

FROM ubuntu:20.04
LABEL Description="This is the development image for ubuntu 20.04 on Flex Series GPU"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
RUN apt-get update && apt-get upgrade -y systemd
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates gpg-agent software-properties-common wget libgtk-3-0 libnuma1 ocl-icd-libopencl1 libglib2.0-0 libegl1 libx11-6 libxv1 libxt6 libasound2 libpangocairo-1.0-0 libcairo-gobject2 libtheora0 libvisual-0.4-0 libgl1-mesa-dri libgl1-mesa-glx libegl1-mesa libgdk-pixbuf2.0-0 libjpeg-turbo8 libpng16-16 zlib1g libsoup2.4-1 openssl libcurl3-gnutls librtmp1 mjpegtools libde265-0 libdrm2 libpciaccess0 libgl1-mesa-dev libva2 libva-drm2 libva-x11-2 libva-wayland2 libgles2 python3-gi python3-gi-cairo python3-dev python3-numpy libglib2.0-dev libxcb-shape0 libxcb-xfixes0 libv4l-0 libass9  && \
  rm -rf /var/lib/apt/lists/*
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY --from=build /opt/dist /
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/all-libs.conf && ldconfig


ENV InferenceEngine_DIR=/usr/local/openvino/runtime/cmake/
ENV TBB_DIR=/usr/local/openvino/runtime/3rdparty/tbb/cmake
ENV ngraph_DIR=/usr/local/openvino/runtime/cmake/
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/openvino/runtime/lib/:/usr/local/openvino/runtime/3rdparty/tbb/lib/
ENV GST_PLUGIN_PATH=/usr/local/lib/gstreamer-1.0
ENV GST_PLUGIN_SCANNER=/usr/local/lib/gstreamer-1.0/gst-plugin-scanner
ENV GST_VAAPI_ALL_DRIVERS=1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal main" | tee /etc/apt/sources.list.d/intel.gpu.focal.list

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-opencl-icd libvpl2 intel-level-zero-gpu level-zero-dev intel-media-va-driver-non-free && \
  rm -rf /var/lib/apt/lists/*

# install DLDT
ARG CUSTOM_IE_DIR=/usr/local/openvino/
ARG CUSTOM_IE_LIBDIR=${CUSTOM_IE_DIR}/runtime/lib/intel64
RUN printf "${CUSTOM_IE_LIBDIR}\n${CUSTOM_IE_DIR}/3rdparty/tbb/lib\n" >/etc/ld.so.conf.d/openvino.conf && ldconfig
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/gstreamer-1.0/
ENV GI_TYPELIB_PATH=${GI_TYPELIB_PATH}:/usr/local/lib/girepository-1.0/ 
ENV PYTHONPATH=${PYTHONPATH}:/opt/intel/dl_streamer/python
ENV GST_PLUGIN_PATH=${GST_PLUGIN_PATH}:/usr/local/lib/gstreamer-1.0/

HEALTHCHECK CMD echo "This is a healthcheck test." || exit 1