
FROM centos:7.6.1810 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz; \
    cd cmake-${CMAKE_VER}; \
    ./bootstrap --prefix="/usr"; \
    make -j8; \
    make install

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO}; \
     tar -xaf nasm*; \
     cd nasm-${NASM_VER}; \
     ./autogen.sh; \
     ./configure --prefix="/usr" --libdir=/usr/lib64; \
     make -j8; \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz; \
     cd yasm-${YASM_VER}; \
     sed -i "s/) ytasm.*/)/" Makefile.in; \
     ./configure --prefix="/usr" --libdir=/usr/lib64; \
     make -j8; \
     make install

# Build ogg
ARG OGG_VER=1.3.3
ARG OGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-${OGG_VER}.tar.xz

RUN wget -O - ${OGG_REPO} | tar xJ; \
    cd libogg-${OGG_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install

# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VER}.tar.xz

RUN wget -O - ${VORBIS_REPO} | tar xJ; \
    cd libvorbis-${VORBIS_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install

# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

RUN wget -O - ${MP3LAME_REPO} | tar xz; \
    cd lame-${MP3LAME_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared --enable-nasm; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac; \
    cd fdk-aac; \
    autoreconf -fiv; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install


# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

RUN wget -O - ${OPUS_REPO} | tar xz; \
    cd opus-${OPUS_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install

# Build vpx
ARG VPX_VER=tags/v1.7.0
ARG VPX_REPO=https://chromium.googlesource.com/webm/libvpx.git

RUN git clone ${VPX_REPO}; \
    cd libvpx; \
    git checkout ${VPX_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install


# Build AOM
ARG AOM_VER=tags/v1.0.0
ARG AOM_REPO=https://aomedia.googlesource.com/aom

RUN  git clone ${AOM_REPO}; \
     mkdir aom/aom_build; \
     cd aom/aom_build; \
     git checkout ${AOM_VER}; \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/lib64 ..; \
     make -j8; \
     make install DESTDIR="/home/build"; \
     make install

# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

RUN  git clone ${X264_REPO}; \
     cd x264; \
     git checkout ${X264_VER}; \
     ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared; \
     make -j8; \
     make install DESTDIR="/home/build"; \
     make install


# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

RUN  yum install -y -q numactl-devel libpciaccess-devel

RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265; \
     cd x265/build/linux; \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_DIR=/usr/lib64 ../../source; \
     make -j8; \
     make install DESTDIR="/home/build"; \
     make install

# Fetch SVT-HEVC
ARG SVT_HEVC_VER=v1.3.0
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

RUN yum install -y -q patch centos-release-scl; \
    yum install -y -q devtoolset-7

RUN git clone ${SVT_HEVC_REPO}; \
    cd SVT-HEVC/Build/linux; \
    git checkout ${SVT_HEVC_VER}; \
    mkdir -p ../../Bin/Release; \
    ( source /opt/rh/devtoolset-7/enable; \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../..; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install )


# Fetch SVT-AV1
ARG SVT_AV1_VER=a39acb2
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN git clone ${SVT_AV1_REPO}; \
    cd SVT-AV1/Build/linux; \
    git checkout ${SVT_AV1_VER}; \
    mkdir -p ../../Bin/Release; \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../..; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install 


# Build DLDT-Inference Engine
ARG DLDT_VER=2018_R4
ARG DLDT_REPO=https://github.com/opencv/dldt.git
RUN git clone -b ${DLDT_VER} ${DLDT_REPO}; \
    cd dldt; \
    git submodule init; \
    git submodule update --recursive; \
    cd inference-engine; \
    mkdir build; \
    cd build; \
    cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_PATH=/usr/lib64 -DENABLE_MKL_DNN=ON -DENABLE_CLDNN=OFF -DENABLE_SAMPLE_CORE=OFF  ..; \
    make -j16; \
    rm -rf ../bin/intel64/Release/lib/libgtest*; \
    rm -rf ../bin/intel64/Release/lib/libgmock*; \
    rm -rf ../bin/intel64/Release/lib/libmock*; \
    rm -rf ../bin/intel64/Release/lib/libtest*; \
    for p in /usr /home/build/usr; do \
        mkdir -p $p/include/dldt; \
        cp -r ../include/* $p/include/dldt; \
        libdir="$p/lib64"; \
        cp -r ../bin/intel64/Release/lib/* "$libdir"; \
        mkdir -p "$libdir/pkgconfig"; \
        pc="$libdir/pkgconfig/dldt.pc"; \
        echo "prefix=/usr" > "$pc"; \
        echo "libdir=/usr/lib64" >> "$pc"; \
        echo "includedir=/usr/include/dldt" >> "$pc"; \
        echo "" >> "$pc"; \
        echo "Name: DLDT" >> "$pc"; \
        echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc"; \
        echo "Version: 4.0" >> "$pc"; \
        echo "" >> "$pc"; \
        echo "Libs: -L\${libdir} -linference_engine" >> "$pc"; \
        echo "Cflags: -I\${includedir}" >> "$pc"; \
    done;

# Build the gstremaer core
ARG GST_VER=1.14.4
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz

RUN  yum install -y -q glib2-devel-2.56.1
RUN  wget -O - ${GST_REPO} | tar xJ; \
     cd gstreamer-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-shared --disable-examples --disable-gst-debug --disable-debug --disable-benchmarks --disable-check; \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

# Build the gstremaer plugin base
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ; \
     cd gst-plugins-base-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-shared --disable-examples --disable-debug; \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install


# Build the gstremaer plugin good set
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ; \
     cd gst-plugins-good-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-shared --disable-examples --disable-debug; \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

# Build the gstremaer plugin bad set
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ; \
     cd gst-plugins-bad-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-shared --disable-examples --disable-debug; \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

# Build the gstremaer plugin ugly set
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ; \
     cd gst-plugins-ugly-${GST_VER}; \
     ./autogen.sh; \
     ./configure --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-shared --disable-examples --disable-debug; \
     make -j8; \
     make install DESTDIR=/home/build; \
     make install

# Build gst-libav
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

RUN yum install -y -q zlib-devel openssl-devel

RUN wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ; \
    cd gst-libav-${GST_VER}; \
    ./configure --prefix="/usr" --libdir=/usr/lib64 --enable-shared --enable-gpl; \
    make -j8; \
    make install DESTDIR="/home/build"



# Clean up after build
RUN rm -rf /home/build/usr/include; \
    rm -rf /home/build/usr/share/doc; \
    rm -rf /home/build/usr/share/gtk-doc; \
    rm -rf /home/build/usr/share/man; \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM centos:7.6.1810
LABEL Description="This is the image for DLDT and GSTREAMER on CentOS 7.6"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN yum install -y epel-release; \
    yum install -y -q numactl openssl glib2-2.56.1 libpng12 libXv ; \
    yum remove -y -q epel-release; \
    rm -rf /var/cache/yum/*;

# Install
COPY --from=build /home/build /

