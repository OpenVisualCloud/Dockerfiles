
FROM centos:7.6.1810 AS build
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

# Build libnice
ARG NICE_VER="0.1.4"
ARG NICE_REPO=http://nice.freedesktop.org/releases/libnice-${NICE_VER}.tar.gz
ARG LIBNICE_PATCH_REPO_01=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-agentlock.patch
ARG LIBNICE_PATCH_REPO_02=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-agentlock-plus.patch
ARG LIBNICE_PATCH_REPO_03=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-removecandidate.patch
ARG LIBNICE_PATCH_REPO_04=https://raw.githubusercontent.com/open-webrtc-toolkit/owt-server/master/scripts/patches/libnice014-keepalive.patch

RUN yum install -y -q glib2-devel

RUN wget -O - ${NICE_REPO} | tar xz && \
    cd libnice-${NICE_VER} && \
    wget -O - ${LIBNICE_PATCH_REPO_01} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_02} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_03} | patch -p1 && \
    wget -O - ${LIBNICE_PATCH_REPO_04} | patch -p1 && \
    ./configure --prefix="/usr" && \
    make -s V= && \
    make install

# Build open ssl
ARG OPENSSL_VER="1.0.2r"
ARG OPENSSL_REPO=http://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz

RUN wget -O - ${OPENSSL_REPO} | tar xz && \
    cd openssl-${OPENSSL_VER} && \
    ./config no-ssl3 --prefix="/usr" -fPIC && \
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

RUN yum install -y -q which

RUN wget -O - ${USRSCTP_URL} | tar xz && \
    mv ${USRSCTP_EXTRACT} usrsctp && \
    cd usrsctp && \
    ./bootstrap && \
    ./configure --prefix="/usr" && \
    make && \
    make install

# Build libsrtp2
ARG SRTP2_VER="2.1.0"
ARG SRTP2_REPO=https://codeload.github.com/cisco/libsrtp/tar.gz/v${SRTP2_VER}

RUN yum install -y -q curl

RUN curl -o libsrtp-${SRTP2_VER}.tar.gz ${SRTP2_REPO} && \
    tar xzf libsrtp-${SRTP2_VER}.tar.gz && \
    cd libsrtp-${SRTP2_VER} && \
    PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig CFLAGS="-fPIC" ./configure --enable-openssl --prefix="/usr" --with-openssl-dir="/usr" && \
    make -s V=0  && \
    make install

# Install node
ARG NODE_VER=v8.15.0
ARG NODE_REPO=https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-linux-x64.tar.xz

RUN yum install -y -q ca-certificates wget xz-utils

RUN wget ${NODE_REPO} && \
    tar xf node-${NODE_VER}-linux-x64.tar.xz && \
    cp node-*/* /usr/ -rf && rm -rf node-*

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


ARG FFMPEG_VER="4.1.1"
ARG FFMPEG_DIR="ffmpeg-${FFMPEG_VER}"
ARG FFMPEG_SRC="${FFMPEG_DIR}.tar.bz2"
ARG FFMPEG_SRC_URL="http://ffmpeg.org/releases/${FFMPEG_SRC}"
ARG FFMPEG_SRC_MD5SUM="4a64e3cb3915a3bf71b8b60795904800"

ARG FDKAAC_VER="0.1.6"
ARG FDKAAC_SRC="fdk-aac-${FDKAAC_VER}.tar.gz"
ARG FDKAAC_SRC_URL="http://sourceforge.net/projects/opencore-amr/files/fdk-aac/${FDKAAC_SRC}/download"
ARG FDKAAC_SRC_MD5SUM="13c04c5f4f13f4c7414c95d7fcdea50f"

RUN yum install -y -q freetype-devel

RUN wget -c ${FFMPEG_SRC_URL} && \
    rm -fr ${FFMPEG_DIR} && \
    tar xf ${FFMPEG_SRC} && \
    cd ${FFMPEG_DIR} && \
    PKG_CONFIG_PATH=/usr/lib/pkgconfig CFLAGS=-fPIC ./configure --prefix=/usr/ --enable-shared --disable-static --disable-libvpx --disable-vaapi --enable-libfreetype --enable-libfdk-aac --enable-nonfree && \
    make -j4 -s V=0 && make install && \
    make install DESTDIR="/home/build"

# Build OWT specific modules

ARG OWTSERVER_REPO=https://github.com/open-webrtc-toolkit/owt-server.git
ARG OPENH264_MAJOR=1
ARG OPENH264_MINOR=7
ARG OPENH264_SOVER=4
ARG OPENH264_SOURCENAME=v${OPENH264_MAJOR}.${OPENH264_MINOR}.0.tar.gz
ARG OPENH264_SOURCE=https://github.com/cisco/openh264/archive/v${OPENH264_MAJOR}.${OPENH264_MINOR}.0.tar.gz
ARG OPENH264_BINARYNAME=libopenh264-${OPENH264_MAJOR}.${OPENH264_MINOR}.0-linux64.${OPENH264_SOVER}.so
ARG OPENH264_BINARY=https://github.com/cisco/openh264/releases/download/v${OPENH264_MAJOR}.${OPENH264_MINOR}.0/${OPENH264_BINARYNAME}.bz2
ARG LICODE_COMMIT="4c92ddb42ad8bd2eab4dfb39bbb49f985b454fc9"
ARG LICODE_CHERRY_PICK="71b38f9bf1d582d5afb1dca8f390c281dbe8ae43"
ARG LICODE_REPO=https://github.com/lynckia/licode.git
ARG LICODE_PATCH_REPO=https://github.com/open-webrtc-toolkit/owt-server/tree/master/scripts/patches/licode/
ARG WEBRTC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-webrtc.git
ARG SVT_VER=v1.3.0
ARG SVT_REPO=https://github.com/intel/SVT-HEVC.git
ARG SERVER_PATH=/home/owt-server
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git

ARG FDKAAC_LIB=/home/build/usr/lib64
RUN yum install -y -q python-devel glib2-devel boost-devel log4cxx-devel

# 1. Clone OWT server source code 
# 2. Clone licode source code and patch
# 3. Clone webrtc source code and patch
RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git clone ${OWTSERVER_REPO} && \

    # Install node modules for owt
    npm install -g --loglevel error node-gyp grunt-cli underscore jsdoc && \
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
    git cherry-pick ${LICODE_CHERRY_PICK} && \

    # Install webrtc for owt
    cd ${SERVER_PATH}/third_party && mkdir webrtc  && cd webrtc &&\
    export GIT_SSL_NO_VERIFY=1 && \
    git clone -b 59-server ${WEBRTC_REPO} src && \
    ./src/tools-woogeen/install.sh && \
    ./src/tools-woogeen/build.sh && \

    # Install specified svt-hevc version for owt
    cd ${SERVER_PATH}/third_party&& git clone ${SVT_REPO} && \
    cd SVT-HEVC && git checkout v1.3.0 && \
    cd Build/linux && chmod +x build.sh && \
    ./build.sh debug && \
    cd ../.. && cp -v ./Bin/Debug/libSvtHevcEnc.so.1 ./ && \
    ln -s -v libSvtHevcEnc.so.1 libSvtHevcEnc.so && \
    echo 'const char* stub() {return "this is a stub lib";}' > pseudo-svtHevcEnc.cpp && \
    gcc pseudo-svtHevcEnc.cpp -fPIC -shared -o pseudo-svtHevcEnc.so && \

    # Get js client sdk for owt
    cd /home && git clone ${OWT_SDK_REPO} && cd owt-client-javascript/scripts && npm install && grunt  && \
    mkdir ${SERVER_PATH}/third_party/quic-lib && \
    cd ${SERVER_PATH}/third_party/quic-lib && wget https://github.com/open-webrtc-toolkit/owt-deps-quic/releases/download/v0.1/dist.tgz && tar xzf dist.tgz && \

    #Build and pack owt
    cd ${SERVER_PATH} && export PKG_CONFIG_PATH=/usr/lib/pkgconfig && ./scripts/build.js -t mcu -r -c && \
    ./scripts/pack.js -t all --install-module --sample-path /home/owt-client-javascript/dist/samples/conference && \
    cd ${SERVER_PATH} && ./dist/video_agent/install_openh264.sh && cp -r ${FDKAAC_LIB}/* ./dist/audio_agent/lib/ && \
    cp -r ${FDKAAC_LIB}/* ./dist/video_agent/lib/ && \
    cp -r ${FDKAAC_LIB}/* ./dist/streaming_agent/lib/ && \
    cp -r ${FDKAAC_LIB}/* ./dist/analytics_agent/lib/ && \
    cp -rf /home/owt-server/dist /home/build/owt

FROM centos:7.6.1810
LABEL Description="This is the image for owt development on CentOS 7.6"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
# Install node
ARG NODE_VER=v8.15.0
ARG NODE_REPO=https://nodejs.org/dist/${NODE_VER}/node-${NODE_VER}-linux-x64.tar.xz

RUN yum install -y -q ca-certificates wget xz-utils

RUN wget ${NODE_REPO} && \
    tar xf node-${NODE_VER}-linux-x64.tar.xz && \
    cp node-*/* /usr/ -rf && rm -rf node-*

COPY --from=build /home/build/owt /home/owt

RUN yum install epel-release boost-system boost-thread log4cxx glib2 freetype-devel -y && \	
    yum install rabbitmq-server mongodb mongodb-server -y && \
    yum remove -y -q epel-release && \
    rm -rf /var/cache/yum/*;


