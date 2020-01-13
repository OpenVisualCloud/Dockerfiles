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
ARG NICE_VER="0.1.4"
ARG NICE_REPO=http://nice.freedesktop.org/releases/libnice-${NICE_VER}.tar.gz
ARG SCVP_VER="1.0.0"
ARG SCVP_REPO=https://github.com/OpenVisualCloud/Immersive-Video-Sample/archive/v${SCVP_VER}.tar.gz
ARG WEBRTC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-webrtc.git
ARG SERVER_PATH=/home/owt-server
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git
ARG OWT_BRANCH=360-video
ARG OWT_BRANCH_JS=master
ARG OWT_BRANCH_JS_COMMIT="d727af2927731ff16214d73f57964a992258636d"
ARG WEBRTC_COMMIT="c2aa290cfe4f63d5bfbb6540122a5e6bf2783187"

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
ARG FDKAAC_LIB=/home/build/usr/local/lib/x86_64-linux-gnu
RUN apt-get update && apt-get install -y -q --no-install-recommends python libglib2.0-dev libboost-thread-dev libboost-system-dev liblog4cxx-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
ARG FDKAAC_LIB=/home/build/usr/local/lib64
RUN yum install -y -q python-devel glib2-devel boost-devel log4cxx-devel
RUN yum install -y -q patch centos-release-scl devtoolset-7
)dnl

# Install 360scvp
RUN cd /home && \
    wget -O - ${SCVP_REPO} | tar xz && mv Immersive-Video-Sample-${SCVP_VER} Immersive-Video-Sample && \
    cd Immersive-Video-Sample/src/360SCVP && \
    mkdir build && \
    cd build && \
ifelse(index(DOCKER_IMAGE,centos),-1,,`dnl
    source /opt/rh/devtoolset-7/enable && \
')dnl
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) ../ && \
    make -j && \
    make install DESTDIR=/home/build && \
    make install

# 1. Clone OWT server source code
# 2. Clone licode source code and patch
# 3. Clone webrtc source code and patch
RUN git clone -b ${OWT_BRANCH} ${OWTSERVER_REPO} && \
ifelse(index(DOCKER_IMAGE,centos),-1,,`dnl
    source /opt/rh/devtoolset-7/enable && \
')dnl

    # Install node modules for owt
    npm config set proxy=${http_proxy} && \
    npm config set https-proxy=${http_proxy} && \
    npm install -g --loglevel error node-gyp grunt-cli underscore jsdoc && \
    cd ${SERVER_PATH} && npm install nan && \

    # Get openh264 for owt
    cd ${SERVER_PATH}/third_party && \
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
    git apply ${SERVER_PATH}/scripts/patches/licode/*.patch && \
    mkdir -p ${SERVER_PATH}/build/libdeps/build/include && \
    cp erizoAPI/lib/json.hpp ${SERVER_PATH}/build/libdeps/build/include && \

    # Install libnice for owt
    cd ${SERVER_PATH}/third_party && \
    wget -O - ${NICE_REPO} | tar xz && \
    cd libnice-${NICE_VER} && \
    patch -p1 < ${SERVER_PATH}/scripts/patches/libnice014-agentlock.patch && \
    patch -p1 < ${SERVER_PATH}/scripts/patches/libnice014-agentlock-plus.patch && \
    patch -p1 < ${SERVER_PATH}/scripts/patches/libnice014-removecandidate.patch && \
    patch -p1 < ${SERVER_PATH}/scripts/patches/libnice014-keepalive.patch && \
    patch -p1 < ${SERVER_PATH}/scripts/patches/libnice014-startcheck.patch && \
    ./configure --prefix="/usr/local" --libdir=/usr/local/lib64 && \
    make -s V= && \
    make install && \

    # Install webrtc for owt
    cd ${SERVER_PATH}/third_party && mkdir webrtc  && cd webrtc &&\
    export GIT_SSL_NO_VERIFY=1 && \
    git clone -b 59-server ${WEBRTC_REPO} src && cd src && \
    git reset --hard ${WEBRTC_COMMIT} && \
    ./tools-woogeen/install.sh && \
    ./tools-woogeen/build.sh && \

    # Get js client sdk for owt
    cd /home && git clone -b ${OWT_BRANCH_JS} ${OWT_SDK_REPO} && cd owt-client-javascript/scripts && git reset --hard ${OWT_BRANCH_JS_COMMIT}  && npm install && grunt  && \
    export LD_LIBRARY_PATH=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    #Build and pack owt
    cd ${SERVER_PATH} && export CPLUS_INCLUDE_PATH=/usr/local/include/svt-hevc && export PKG_CONFIG_PATH=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig && ifelse(index(DOCKER_IMAGE,xeon-),-1,./scripts/build.js -t mcu-all -r -c && \,./scripts/build.js -t mcu -r -c && \)
    ./scripts/pack.js -t all --install-module --no-pseudo --sample-path /home/owt-client-javascript/dist/samples/conference
