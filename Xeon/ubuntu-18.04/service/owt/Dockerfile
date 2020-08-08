
FROM ubuntu:18.04 AS build
WORKDIR /home

# COMMON BUILD TOOLS
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3009
RUN apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr/local" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
    RUN apt-get install -y -q --no-install-recommends automake	&& \
        apt-get clean	&& \
        rm -rf /var/lib/apt/lists/*

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu && \
     make -j8 && \
     make install

# Build libnice
ARG NICE_VER="0.1.4"
ARG NICE_REPO=http://nice.freedesktop.org/releases/libnice-${NICE_VER}.tar.gz
ARG LIBNICE_PATCH_VER="4.3.1"
ARG LIBNICE_PATCH_REPO=https://github.com/open-webrtc-toolkit/owt-server/archive/v${LIBNICE_PATCH_VER}.tar.gz

RUN apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O - ${NICE_REPO} | tar xz && \
    cd libnice-${NICE_VER} && \
    wget -O - ${LIBNICE_PATCH_REPO} | tar xz  && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-agentlock.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-agentlock-plus.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-removecandidate.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-keepalive.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-startcheck.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-closelock.patch && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu && \
    make -s V= && \
    make install


# Build open ssl
ARG OPENSSL_BASE_VER="1.0.2"
ARG OPENSSL_VER="1.0.2t"
ARG OPENSSL_REPO=http://www.openssl.org/source/old/${OPENSSL_BASE_VER}/openssl-${OPENSSL_VER}.tar.gz

RUN wget -O - ${OPENSSL_REPO} | tar xz && \
    cd openssl-${OPENSSL_VER} && \
    ./config no-ssl3 --prefix="/usr/local" -fPIC && \
    make depend && \
    make -s V=0  && \
    make install

# Build libre
ARG LIBRE_VER="v0.4.16"
ARG LIBRE_REPO=https://github.com/creytiv/re.git

RUN git clone ${LIBRE_REPO} && \
    cd re && \
    git checkout ${LIBRE_VER} && \
    make SYSROOT_ALT="/usr" RELEASE=1 && \
    make install SYSROOT_ALT="/usr" RELEASE=1 PREFIX="/usr"

# Build usrsctp

ARG USRSCTP_VERSION="30d7f1bd0b58499e1e1f2415e84d76d951665dc8"
ARG USRSCTP_FILE="${USRSCTP_VERSION}.tar.gz"
ARG USRSCTP_EXTRACT="usrsctp-${USRSCTP_VERSION}"
ARG USRSCTP_URL="https://github.com/sctplab/usrsctp/archive/${USRSCTP_FILE}"


RUN wget -O - ${USRSCTP_URL} | tar xz && \
    mv ${USRSCTP_EXTRACT} usrsctp && \
    cd usrsctp && \
    ./bootstrap && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu && \
    make && \
    make install

# Build libsrtp2
ARG SRTP2_VER="2.1.0"
ARG SRTP2_REPO=https://codeload.github.com/cisco/libsrtp/tar.gz/v${SRTP2_VER}

RUN apt-get update && apt-get install -y -q --no-install-recommends curl

RUN curl -o libsrtp-${SRTP2_VER}.tar.gz ${SRTP2_REPO} && \
    tar xzf libsrtp-${SRTP2_VER}.tar.gz && \
    cd libsrtp-${SRTP2_VER} && \
    export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig" && \
    export CFLAGS="-fPIC" && \
    ./configure --enable-openssl --prefix="/usr/local" --with-openssl-dir="/usr/local" && \
    make -s V=0  && \
    make install

# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu --enable-shared && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install


# Fetch FFmpeg source
ARG FFMPEG_VER=n4.1
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw
ARG FFMPEG_THREAD_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11035/raw

ARG FFMPEG_PATCHES_RELEASE_VER=0.1
ARG FFMPEG_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${FFMPEG_PATCHES_RELEASE_VER}.tar.gz
ARG FFMPEG_PATCHES_PATH=/home/CDN-${FFMPEG_PATCHES_RELEASE_VER}
RUN wget -O - ${FFMPEG_PATCHES_RELEASE_URL} | tar xz


RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libass-dev libfreetype6-dev zlib1g-dev libssl-dev	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg ;

# Compile FFmpeg
RUN cd /home/FFmpeg && \
    export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig" && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib/x86_64-linux-gnu --enable-shared --disable-static --disable-libvpx --disable-vaapi --enable-libfreetype --enable-libfdk-aac  --enable-nonfree && \

    make -j8 && \
    make install && make install DESTDIR="/home/build"


# Install node
ARG NODE_VER=v8.15.0
ARG NODE_REPO=https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-linux-x64.tar.xz

RUN apt-get update && apt-get install -y -q --no-install-recommends ca-certificates wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget ${NODE_REPO} && \
    tar xf node-${NODE_VER}-linux-x64.tar.xz && \
    cp node-*/* /usr/local -rf && \
    rm -rf node-*

# Fetch SVT-HEVC
ARG SVT_HEVC_VER=v1.3.0
ARG SVT_HEVC_REPO=https://github.com/intel/SVT-HEVC

# hadolint ignore=SC1091
RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig" && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install 


# Build OWT specific modules

ARG OWTSERVER_REPO=https://github.com/open-webrtc-toolkit/owt-server.git
ARG OPENH264_MAJOR=1
ARG OPENH264_MINOR=7
ARG OPENH264_SOVER=4
ARG OPENH264_SOURCENAME=v${OPENH264_MAJOR}.${OPENH264_MINOR}.0.tar.gz
ARG OPENH264_SOURCE=https://github.com/cisco/openh264/archive/v${OPENH264_MAJOR}.${OPENH264_MINOR}.0.tar.gz
ARG OPENH264_BINARYNAME=libopenh264-${OPENH264_MAJOR}.${OPENH264_MINOR}.0-linux64.${OPENH264_SOVER}.so
ARG OPENH264_BINARY=https://github.com/cisco/openh264/releases/download/v${OPENH264_MAJOR}.${OPENH264_MINOR}.0/${OPENH264_BINARYNAME}.bz2
ARG LICODE_COMMIT="8b4692c88f1fc24dedad66b4f40b1f3d804b50ca"
ARG LICODE_REPO=https://github.com/lynckia/licode.git
ARG LICODE_PATCH_REPO=https://github.com/open-webrtc-toolkit/owt-server/tree/master/scripts/patches/licode/
ARG WEBRTC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-webrtc.git
ARG SVT_VER=v1.3.0
ARG SVT_REPO=https://github.com/intel/SVT-HEVC.git
ARG SERVER_PATH=/home/owt-server
ARG SOURCE_DIR=/home
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git
ARG OWT_BRANCH=4.3.x
ARG DOWNLOAD_JSON_LINK="https://github.com/nlohmann/json/releases/download/v3.6.1/json.hpp"

ARG FDKAAC_LIB=/home/build/usr/local/lib/x86_64-linux-gnu
RUN apt-get update && apt-get install -y -q --no-install-recommends python libglib2.0-dev libboost-thread-dev libboost-system-dev liblog4cxx-dev 

# 1. Clone OWT server source code 
# 2. Clone licode source code and patch
# 3. Clone webrtc source code and patch
RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
     cd ${SOURCE_DIR} && git clone -b ${OWT_BRANCH} ${OWTSERVER_REPO} && \

    # Get json hpp file
    wget -P /usr/include ${DOWNLOAD_JSON_LINK}  && \

    # Install node modules for owt
    npm install -g --loglevel error node-gyp@v6.1.0 grunt-cli underscore jsdoc && \
    cd owt-server && npm install nan && \

    # Get openh264 for owt
    cd third_party && \
    mkdir openh264 && cd openh264 && \
    wget ${OPENH264_SOURCE} && \
    wget ${OPENH264_BINARY} && \
    tar xzf ${OPENH264_SOURCENAME} openh264-${OPENH264_MAJOR}.${OPENH264_MINOR}.0/codec/api && \
    ln -s -v openh264-${OPENH264_MAJOR}.${OPENH264_MINOR}.0/codec codec && \
    bzip2 -d ${OPENH264_BINARYNAME}.bz2 && \
    ln -s -v ${OPENH264_BINARYNAME} libopenh264.so.${OPENH264_SOVER} && \
    ln -s -v libopenh264.so.${OPENH264_SOVER} libopenh264.so && \
    echo 'const char* stub() {return "this is a stub lib";}' > pseudo-openh264.cpp && \
    gcc pseudo-openh264.cpp -fPIC -shared -o pseudo-openh264.so && \ 

    # Get licode for owt
    cd ${SERVER_PATH}/third_party && git clone ${LICODE_REPO} && \
    cd licode && \
    git reset --hard ${LICODE_COMMIT} && \
    wget -r -nH --cut-dirs=5 --no-parent ${LICODE_PATCH_REPO} && \
    git am ${SERVER_PATH}/scripts/patches/licode/*.patch && \

    # Install webrtc for owt
    cd ${SERVER_PATH}/third_party && mkdir webrtc  && cd webrtc &&\
    export GIT_SSL_NO_VERIFY=1 && \
    git clone -b 59-server ${WEBRTC_REPO} src && \
    ./src/tools-woogeen/install.sh && \
    ./src/tools-woogeen/build.sh && \

    # Get js client sdk for owt
    cd ${SOURCE_DIR} && git clone -b ${OWT_BRANCH} ${OWT_SDK_REPO} && cd owt-client-javascript/scripts && npm install && grunt  && \
    mkdir ${SERVER_PATH}/third_party/quic-lib && \
    export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu && \
    cd ${SERVER_PATH}/third_party/quic-lib && wget https://github.com/open-webrtc-toolkit/owt-deps-quic/releases/download/v0.1/dist.tgz && tar xzf dist.tgz && \
    cd ${SERVER_PATH} && export PKG_CONFIG_PATH=/usr/local/lib/x86_64-linux-gnu/pkgconfig && ./scripts/build.js -t mcu -r -c && \
    ./scripts/pack.js -t all --install-module --no-pseudo --sample-path /home/owt-client-javascript/dist/samples/conference

FROM ubuntu:18.04 
LABEL Description="This is the image for owt development on Ubuntu 18.04"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
# Install node
ARG NODE_VER=v8.15.0
ARG NODE_REPO=https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-linux-x64.tar.xz

RUN apt-get update && apt-get install -y -q --no-install-recommends ca-certificates wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget ${NODE_REPO} && \
    tar xf node-${NODE_VER}-linux-x64.tar.xz && \
    cp node-*/* /usr/local -rf && \
    rm -rf node-*

COPY --from=build /home/owt-server/dist /home/owt
COPY --from=build /home/build /

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/x86_64-linux-gnu
RUN echo -e "\x1b[32mInstalling dependent components and libraries via apt-get...\x1b[0m" && \
    apt-get update && \
    apt-get install --no-install-recommends rabbitmq-server mongodb libboost-system-dev libboost-thread-dev liblog4cxx-dev libglib2.0-0 libfreetype6-dev curl -y && \ 
            echo "#!/bin/bash -e" >> /home/launch.sh && \
    echo "service mongodb start &" >> /home/launch.sh && \
    echo "service rabbitmq-server start &" >> /home/launch.sh && \
    echo "while ! mongo --quiet --eval \"db.adminCommand('listDatabases')\"" >> /home/launch.sh && \
    echo "do" >> /home/launch.sh && \
    echo "  echo mongod not launch" >> /home/launch.sh && \
    echo "  sleep 1" >> /home/launch.sh && \
    echo "done" >> /home/launch.sh && \
    echo "echo mongodb connected successfully" >> /home/launch.sh && \
    echo "cd /home/owt" >> /home/launch.sh && \
        echo "./management_api/init.sh && ./bin/start-all.sh " >> /home/launch.sh && \
    chmod +x /home/launch.sh && \
    export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig" && \
    
    rm -rf /var/lib/apt/lists/*;


