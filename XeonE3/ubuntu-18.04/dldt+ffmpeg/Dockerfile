
FROM ubuntu:18.04 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev

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
    RUN apt-get install -y -q automake

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build ogg
ARG OGG_VER=1.3.3
ARG OGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-${OGG_VER}.tar.xz

RUN wget -O - ${OGG_REPO} | tar xJ && \
    cd libogg-${OGG_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VER}.tar.xz

RUN wget -O - ${VORBIS_REPO} | tar xJ && \
    cd libvorbis-${VORBIS_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

RUN wget -O - ${MP3LAME_REPO} | tar xz && \
    cd lame-${MP3LAME_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared --enable-nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

RUN wget -O - ${OPUS_REPO} | tar xz && \
    cd opus-${OPUS_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

# Build vpx
ARG VPX_VER=tags/v1.7.0
ARG VPX_REPO=https://chromium.googlesource.com/webm/libvpx.git

RUN git clone ${VPX_REPO} && \
    cd libvpx && \
    git checkout ${VPX_VER} && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
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
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/lib/x86_64-linux-gnu .. && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Build x264
ARG X264_VER=stable
ARG X264_REPO=https://github.com/mirror/x264

RUN  git clone ${X264_REPO} && \
     cd x264 && \
     git checkout ${X264_VER} && \
     ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --enable-shared && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install


# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libnuma-dev

RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265 && \
     cd x265/build/linux && \
     cmake -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr -DLIB_INSTALL_DIR=/usr/lib/x86_64-linux-gnu ../../source && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install

# Fetch SVT-HEVC
ARG SVT_HEVC_VER=20a47b0d904e9d99e089d93d7c33af92788cbfdb
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install 


# Fetch SVT-AV1
ARG SVT_AV1_VER=90b56a80795d4d0448673c4c7276ce6d5c8ac9d4
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN git clone ${SVT_AV1_REPO} && \
    cd SVT-AV1/Build/linux && \
    git checkout ${SVT_AV1_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
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
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install 

# Fetch gmmlib
ARG GMMLIB_VER=intel-gmmlib-18.3.0
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz

RUN wget -O - ${GMMLIB_REPO} | tar xz && mv gmmlib-${GMMLIB_VER} gmmlib;


# Build libdrm
ARG LIBDRM_VER=2.4.96
ARG LIBDRM_REPO=https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VER}.tar.gz

RUN apt-get update && apt-get install -y -q --no-install-recommends libpciaccess-dev

RUN wget -O - ${LIBDRM_REPO} | tar xz && \
    cd libdrm-${LIBDRM_VER} && \
    ./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ;


# Build libva
ARG LIBVA_VER=2.4.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz

RUN apt-get remove libva*

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libx11-dev xorg-dev libgl1-mesa-dev openbox

RUN wget -O - ${LIBVA_REPO} | tar xz && \
    cd libva-${LIBVA_VER} && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;


# Build libva-utils
ARG LIBVA_UTILS_VER=2.4.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz

RUN wget -O - ${LIBVA_UTILS_REPO} | tar xz; \
    cd libva-utils-${LIBVA_UTILS_VER}; \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu; \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install;


# Build media driver
ARG MEDIA_DRIVER_VER=intel-media-kbl-19.1.0
ARG MEDIA_DRIVER_REPO=https://github.com/VCDP/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libpciaccess-dev libx11-dev xorg-dev libgl1-mesa-dev

RUN wget -O - ${MEDIA_DRIVER_REPO} | tar xz && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
    mkdir -p media-driver/build && \
    cd media-driver/build && \
    cmake -DBUILD_TYPE=release -DBUILD_ALONG_WITH_CMRTLIB=1 -DMEDIA_VERSION="2.0.0" -DBS_DIR_GMMLIB=/home/gmmlib/Source/GmmLib -DBS_DIR_COMMON=/home/gmmlib/Source/Common -DBS_DIR_INC=/home/gmmlib/Source/inc -DBS_DIR_MEDIA=/home/media-driver -Wno-dev -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install



# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-KBL-2019-R1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz

RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK && \
    mkdir -p MediaSDK/build && \
    cd MediaSDK/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_INCLUDEDIR=include/mfx -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    rm -rf /home/build/usr/samples && \
    rm -rf /home/build/usr/plugins && \
    make install;

#install OpenCL

RUN mkdir neo

RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-gmmlib_18.4.0.348_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-igc-core_18.50.1270_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-igc-opencl_18.50.1270_amd64.deb
RUN cd neo && wget https://github.com/intel/compute-runtime/releases/download/19.01.12103/intel-opencl_19.01.12103_amd64.deb

RUN cd neo && \
    dpkg -i *.deb && \
    dpkg-deb -x intel-gmmlib_18.4.0.348_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-core_18.50.1270_amd64.deb /home/build/ && \
    dpkg-deb -x intel-igc-opencl_18.50.1270_amd64.deb /home/build/ && \
    dpkg-deb -x intel-opencl_19.01.12103_amd64.deb /home/build/



#clinfo needs to be installed after build directory is copied over

# Build DLDT-Inference Engine
ARG DLDT_VER=2019_R1
ARG DLDT_REPO=https://github.com/opencv/dldt.git
ARG DLDT_C_API_1=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/0001-Add-inference-engine-C-API.patch
ARG DLDT_C_API_2=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/0002-Change-to-match-image-with-separate-planes.patch
ARG DLDT_C_API_3=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/0003-Refine-IE-C-API.patch
ARG DLDT_C_API_4=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/thirdparty/0004-Fix-code-style-and-symbols-visibility-for-2019R1.patch


RUN git clone -b ${DLDT_VER} ${DLDT_REPO} && \
    cd dldt && \
    git submodule init && \
    git submodule update --recursive && \
    cd inference-engine && \
    wget -O - ${DLDT_C_API_1} | patch -p2 && \
    wget -O - ${DLDT_C_API_2} | patch -p2 && \
    wget -O - ${DLDT_C_API_3} | patch -p2 && \
    wget -O - ${DLDT_C_API_4} | patch -p2 && \
    mkdir build && \
    cd build && \
    cmake  -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt -DLIB_INSTALL_PATH=/opt/intel/dldt -DENABLE_MKL_DNN=ON -DENABLE_CLDNN=ON -DENABLE_SAMPLE_CORE=OFF  .. && \
    make -j $(nproc) && \
    rm -rf ../bin/intel64/Release/lib/libgtest* && \
    rm -rf ../bin/intel64/Release/lib/libgmock* && \
    rm -rf ../bin/intel64/Release/lib/libmock* && \
    rm -rf ../bin/intel64/Release/lib/libtest*

ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

RUN mkdir -p /opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
    mkdir -p ${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/* ${libdir} && \
    mkdir -p /opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
    mkdir -p /opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* /opt/intel/dldt/inference-engine/share/ && \
    mkdir -p /opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/tbb /opt/intel/dldt/inference-engine/external/

RUN mkdir -p build/opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* build/opt/intel/dldt/inference-engine/include && \
    mkdir -p build${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/* build${libdir} && \
    mkdir -p build/opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* build/opt/intel/dldt/inference-engine/src/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* build/opt/intel/dldt/inference-engine/share/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/tbb build/opt/intel/dldt/inference-engine/external/

RUN for p in /usr /home/build/usr /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
        pkgconfiglibdir="$p/lib/x86_64-linux-gnu" && \
        mkdir -p "${pkgconfiglibdir}/pkgconfig" && \
        pc="${pkgconfiglibdir}/pkgconfig/dldt.pc" && \
        echo "prefix=/opt" > "$pc" && \
        echo "libdir=${libdir}" >> "$pc" && \
        echo "includedir=/opt/intel/dldt/inference-engine/include" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Name: DLDT" >> "$pc" && \
        echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc" && \
        echo "Version: 5.0" >> "$pc" && \
        echo "" >> "$pc" && \
        echo "Libs: -L\${libdir} -linference_engine -linference_engine_c_wrapper" >> "$pc" && \
        echo "Cflags: -I\${includedir}" >> "$pc"; \
    done;

ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}

#install Model Optimizer in the DLDT for Dev



# Build libcjson
ARG LIBCJSON_VER=1.7.11
ARG LIBCJSON_PKG_NAME=v${LIBCJSON_VER}
ARG LIBCJSON_REPO=https://github.com/DaveGamble/cJSON/archive/${LIBCJSON_PKG_NAME}.tar.gz

RUN wget -O - ${LIBCJSON_REPO} | tar xz && \
    cd cJSON-${LIBCJSON_VER} && \
    mkdir build && cd build && \
    cmake .. -DENABLE_CJSON_UTILS=On -DENABLE_CJSON_TEST=Off -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    make install;

# Build librdkafka
ARG LIBRDKAFKA_VER=0.11.6
ARG FILE_NAME=v${LIBRDKAFKA_VER}
ARG LIBRDKAFKA_REPO=https://github.com/edenhill/librdkafka/archive/${FILE_NAME}.tar.gz

RUN wget -O - ${LIBRDKAFKA_REPO} | tar xz && \
    cd librdkafka-${LIBRDKAFKA_VER} && \
    ./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;

# Fetch FFmpeg source
ARG FFMPEG_VER=n4.1
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_FLV_PATCH_REPO=https://raw.githubusercontent.com/VCDP/CDN/master/The-RTMP-protocol-extensions-for-H.265-HEVC.patch
ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw
ARG FFMPEG_THREAD_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11035/raw
ARG FFMPEG_MA_PATCH_REPO_01=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0001-Intel-inference-engine-detection-filter.patch
ARG FFMPEG_MA_PATCH_REPO_02=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0002-New-filter-to-do-inference-classify.patch
ARG FFMPEG_MA_PATCH_REPO_03=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0003-iemetadata-convertor-muxer.patch
ARG FFMPEG_MA_PATCH_REPO_04=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0004-Kafka-protocol-producer.patch
ARG FFMPEG_MA_PATCH_REPO_05=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0005-Support-object-detection-and-featured-face-identific.patch
ARG FFMPEG_MA_PATCH_REPO_06=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0006-Send-metadata-in-a-packet-and-refine-the-json-format.patch
ARG FFMPEG_MA_PATCH_REPO_07=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0007-Refine-features-of-IE-filters.patch
ARG FFMPEG_MA_PATCH_REPO_08=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0008-fixed-extra-comma-in-iemetadata.patch
ARG FFMPEG_MA_PATCH_REPO_09=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0009-add-source-as-option-source-url-calculate-nano-times.patch
ARG FFMPEG_MA_PATCH_REPO_10=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0010-fixed-buffer-overflow-issue-in-iemetadata.patch
ARG FFMPEG_MA_PATCH_REPO_11=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0011-libavutil-add-RGBP-pixel-format.patch
ARG FFMPEG_MA_PATCH_REPO_12=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0012-Add-more-devices-into-target.patch
ARG FFMPEG_MA_PATCH_REPO_13=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0013-Enable-vaapi-scale-for-IE-inference-filter.patch
ARG FFMPEG_MA_PATCH_REPO_14=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0014-iemetadata-it-will-provide-data-frame-by-frame-by-de.patch
ARG FFMPEG_MA_PATCH_REPO_15=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0015-Add-libcjson-for-model-pre-post-processing.patch
ARG FFMPEG_MA_PATCH_REPO_16=https://raw.githubusercontent.com/VCDP/FFmpeg-patch/master/media-analytics/0016-Change-IE-filters-to-use-model-proc.patch

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libass-dev libfreetype6-dev libvdpau-dev libsdl2-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev zlib1g-dev libssl-dev

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg && \
    wget -O - ${FFMPEG_FLV_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_THREAD_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_01} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_02} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_03} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_04} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_05} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_06} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_07} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_08} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_09} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_10} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_11} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_12} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_13} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_14} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_15} | patch -p1 && \
    wget -O - ${FFMPEG_MA_PATCH_REPO_16} | patch -p1;

# Patch FFmpeg source for SVT-HEVC
RUN cd /home/FFmpeg && \
    patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
RUN cd /home/FFmpeg; \
    patch -p1 < ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1-with-svt-hevc.patch;

# Compile FFmpeg
RUN cd /home/FFmpeg && \
    ./configure --prefix="/usr" --libdir=/usr/lib/x86_64-linux-gnu --extra-libs="-lpthread -lm" --enable-shared --enable-gpl --enable-libass --enable-libfreetype  --enable-openssl --enable-nonfree --enable-libdrm --enable-libmfx --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom --enable-libsvthevc --enable-libsvtav1 --enable-libinference_engine --enable-librdkafka  && \
    make -j8 && \
    make install DESTDIR="/home/build"


# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM ubuntu:18.04
LABEL Description="This is the base image for FFMPEG & DLDT Ubuntu 18.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime; \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends  libxv1 libxcb-shm0 libxcb-shape0 libxcb-xfixes0 libsdl2-2.0-0 libasound2 libvdpau1 libnuma1 libass9 libssl1.1 libpciaccess0   libdrm2 ; \
    rm -rf /var/lib/apt/lists/*;

# Install
COPY --from=build /home/build /
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
ENV LIBVA_DRIVER_NAME=iHD
RUN apt-get update && apt-get install -y clinfo
ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share

