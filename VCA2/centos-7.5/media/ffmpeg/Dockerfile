
FROM centos:7.5.1804 AS build
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

# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

RUN wget -O - ${MP3LAME_REPO} | tar xz && \
    cd lame-${MP3LAME_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared --enable-nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
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

#include(transform360.m4)
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



# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-KBL-2019-R1-HF1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz

RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK && \
    mkdir -p MediaSDK/build && \
    cd MediaSDK/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_INCLUDEDIR=include -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    rm -rf /home/build/usr/samples && \
    rm -rf /home/build/usr/plugins && \
    make install;

# Fetch FFmpeg source
ARG FFMPEG_VER=n4.1
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_FLV_PATCH_REPO=https://raw.githubusercontent.com/VCDP/CDN/master/0001-Add-SVT-HEVC-FLV-support-on-FFmpeg.patch
ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw
ARG FFMPEG_THREAD_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11035/raw

RUN yum install -y -q libass-devel freetype-devel SDL2-devel libxcb-devel libvdpau-devel zlib-devel openssl-devel

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg && \
    wget -O - ${FFMPEG_FLV_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_THREAD_PATCH_REPO} | patch -p1 ;
# Patch FFmpeg source for SVT-HEVC
RUN cd /home/FFmpeg && \
    patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
RUN cd /home/FFmpeg; \
    patch -p1 < ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1-with-svt-hevc.patch;

# Compile FFmpeg
RUN cd /home/FFmpeg && \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --extra-libs="-lpthread -lm" --enable-shared --enable-gpl --enable-libass --enable-libfreetype  --enable-openssl --enable-nonfree --enable-libdrm --enable-libmfx --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom --enable-libsvthevc --enable-libsvtav1  && \
    make -j8 && \
    make install DESTDIR="/home/build"


# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM centos:7.5.1804
LABEL Description="This is the base image for FFMPEG CentOS 7.5"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN yum install -y epel-release; \
    yum install -y -q   libxcb SDL2 libass numactl libvdpau  libpciaccess libX11 mesa-dri-drivers mesa-libGL libdrm  ; \
    yum remove -y -q epel-release; \
    rm -rf /var/cache/yum/*;

# Install
COPY --from=build /home/build /
ENV LIBVA_DRIVERS_PATH=/usr/lib64/dri
ENV LIBVA_DRIVER_NAME=iHD

