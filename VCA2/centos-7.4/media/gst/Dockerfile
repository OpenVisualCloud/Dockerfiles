
FROM centos:7.4.1708 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/lib64 --disable-doc && \ 
    make -j8 && \
    make install

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix="/usr" --libdir=/usr/lib64 && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix="/usr" --libdir=/usr/lib64 && \
     make -j8 && \
     make install

# Build ogg
ARG OGG_VER=1.3.3
ARG OGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-${OGG_VER}.tar.xz

RUN wget -O - ${OGG_REPO} | tar xJ && \
    cd libogg-${OGG_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VER}.tar.xz

RUN wget -O - ${VORBIS_REPO} | tar xJ && \
    cd libvorbis-${VORBIS_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install



# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

RUN wget -O - ${OPUS_REPO} | tar xz && \
    cd opus-${OPUS_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vpx
ARG VPX_VER=tags/v1.7.0
ARG VPX_REPO=https://chromium.googlesource.com/webm/libvpx.git

RUN git clone ${VPX_REPO} && \
    cd libvpx && \
    git checkout ${VPX_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build AOM
ARG AOM_VER=b6f1767eedbaddeb1ff5aa409a710ef61078640e
ARG AOM_REPO=https://aomedia.googlesource.com/aom

RUN  git clone ${AOM_REPO} && \
     mkdir aom/aom_build && \
     cd aom/aom_build && \
     git checkout ${AOM_VER} && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/lib64 .. && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

RUN  git clone ${X264_REPO} && \
     cd x264 && \
     git checkout ${X264_VER} && \
     ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install


# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

RUN  yum install -y -q numactl-devel libpciaccess-devel

RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265 && \
     cd x265/build/linux && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_DIR=/usr/lib64 ../../source && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Fetch SVT-HEVC
ARG SVT_HEVC_VER=20a47b0d904e9d99e089d93d7c33af92788cbfdb
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

RUN yum install -y -q patch centos-release-scl && \
    yum install -y -q devtoolset-7

RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    ( source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install )


# Fetch SVT-AV1
ARG SVT_AV1_VER=v0.6.0
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN git clone ${SVT_AV1_REPO} && \
    cd SVT-AV1/Build/linux && \
    git checkout ${SVT_AV1_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi


# Fetch SVT-VP9
ARG SVT_VP9_VER=d18b4acf9139be2e83150e318ffd3dba1c432e74
ARG SVT_VP9_REPO=https://github.com/OpenVisualCloud/SVT-VP9

RUN git clone ${SVT_VP9_REPO} && \
    cd SVT-VP9/Build/linux && \
    git checkout ${SVT_VP9_VER} && \
    mkdir -p ../../Bin/Release && \
  ( source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install )

# Fetch gmmlib
ARG GMMLIB_VER=intel-gmmlib-18.3.0
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz

RUN wget -O - ${GMMLIB_REPO} | tar xz && mv gmmlib-${GMMLIB_VER} gmmlib;


#include(libdrm.m4)
# Build libva
ARG LIBVA_VER=2.4.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz

RUN yum install -y -q libX11-devel mesa-libGL-devel which libdrm-devel

RUN wget -O - ${LIBVA_REPO} | tar xz && \
    cd libva-${LIBVA_VER} && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib64 && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;


# Build media driver
ARG MEDIA_DRIVER_VER=intel-media-kbl-19.1.1
ARG MEDIA_DRIVER_REPO=https://github.com/VCDP/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz

RUN yum install -y -q libX11-devel mesa-libGL-devel libpciaccess-devel libXext-devel

RUN wget -O - ${MEDIA_DRIVER_REPO} | tar xz && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
    mkdir -p media-driver/build && \
    cd media-driver/build && \
    cmake -DBUILD_TYPE=release -DBUILD_ALONG_WITH_CMRTLIB=1 -DMEDIA_VERSION="2.0.0" -DBS_DIR_GMMLIB=/home/gmmlib/Source/GmmLib -DBS_DIR_COMMON=/home/gmmlib/Source/Common -DBS_DIR_INC=/home/gmmlib/Source/inc -DBS_DIR_MEDIA=/home/media-driver -Wno-dev -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install



# Build the gstremaer core
ARG GST_VER=1.16.0
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz

RUN  yum install -y -q glib2-devel-2.56.1 gettext-devel gobject-introspection gobject-introspection-devel python-gobject-base
RUN  wget -O - ${GST_REPO} | tar xJ && \
     cd gstreamer-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --enable-introspection \
        --disable-examples \
        --disable-debug \
        --disable-benchmarks \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install;

# Build the gstremaer plugin base
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz

RUN  yum install -y -q libXv-devel libvisual-devel libtheora-devel glib2-devel alsa-lib-devel cdparanoia-devel mesa-libGL-devel pango-devel

RUN  yum install -y -q libXrandr-devel


RUN  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ && \
     cd gst-plugins-base-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-introspection \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install


# Build the gstremaer plugin good set
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz

RUN  yum install -y -q libsoup-devel libjpeg-devel

RUN  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ && \
     cd gst-plugins-good-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install


# Build the gstreamer plugin bad set
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz
ARG GST_PATCHES_RELEASE_VER=v0.1
ARG GST_PATCHES_RELEASE_URL=https://github.com/VCDP/gstreamer-patch/archive/${GST_PATCHES_RELEASE_VER}.tar.gz
RUN wget -O - ${GST_PATCHES_RELEASE_URL} | tar xz

RUN  yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && yum install -y -q openssl-devel librtmp-devel && yum remove -y rpmfusion-free-release

RUN  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
     cd gst-plugins-bad-${GST_VER} && \
     find /home/gstreamer-patch-${GST_PATCHES_RELEASE_VER#*v}/ -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc \ 
        --disable-shm \
        --disable-mxf && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

# Build the gstremaer plugin ugly set
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ; \
     cd gst-plugins-ugly-${GST_VER}; \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

# Build gst-libav
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

RUN yum install -y -q zlib-devel openssl-devel

RUN wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ && \
    cd gst-libav-${GST_VER} && \
    ./autogen.sh \
        --prefix="/usr" \
        --libdir=/usr/lib64 \
        --enable-shared \
        --enable-gpl \
        --disable-gtk-doc && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install


# Build gstremaer plugin for svt

RUN cd SVT-HEVC/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

RUN cd SVT-VP9/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

RUN cd SVT-AV1/gstreamer-plugin && \
    cmake . && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build gstremaer plugin vaapi
ARG GST_PLUGIN_VAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-${GST_VER}.tar.xz

# https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/merge_requests/45
ARG GST_PLUGIN_VAAPI_REPO_DISPLAY_LOCK_PATCH_HASH=b219f6095f3014041896714dd88e7d90ee3d72dd
ARG GST_PLUGIN_VAAPI_REPO_GIT=https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git

RUN  yum install -y -q libXrandr-devel

#RUN  git clone https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git -b 1.14 --depth 10 && \
#     cd gstreamer-vaapi && git reset --hard ${GST_PLUGIN_VAAPI_REPO_DISPLAY_LOCK_PATCH_HASH} && \
RUN  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ && \
     cd gstreamer-vaapi-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples \
        --disable-gtk-doc --disable-debug && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install


# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    rm -rf /home/build/usr/local/include && \
    rm -rf /home/build/usr/local/share/doc && \
    rm -rf /home/build/usr/local/share/gtk-doc && \
    rm -rf /home/build/usr/local/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM centos:7.4.1708
LABEL Description="This is the base image for GStreamer CentOS 7.4"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN yum install -y epel-release;  \
    yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm; \
    yum install -y -q numactl openssl glib2-2.56.1 pango gobject-introspection libxcb mesa-libGL libXrandr libpng12 libXv libvisual mesa-libGL pango glib2 alsa-lib cdparanoia libtheora libpciaccess libX11 mesa-dri-drivers mesa-libGL libdrm  libsoup libjpeg-turbo librtmp ; \
    yum remove -y -q epel-release; \
    yum remove -y -q rpmfusion-free-release; \
    rm -rf /var/cache/yum/*;

# Install
COPY --from=build /home/build /
ENV LIBVA_DRIVERS_PATH=/usr/lib64/dri
ENV LIBVA_DRIVER_NAME=iHD
ENV GST_VAAPI_ALL_DRIVERS=1
ENV DISPLAY=:0.0

