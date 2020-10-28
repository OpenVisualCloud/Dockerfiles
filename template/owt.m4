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
ARG SERVER_PATH=ifelse(BUILD_DEV,enabled,/home/build/home/owt-server,/home/owt-server)
ARG SOURCE_DIR=ifelse(BUILD_DEV,enabled,/home/build/home,/home)
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git
ARG OWT_BRANCH=4.3.x
ARG DOWNLOAD_JSON_LINK="https://github.com/nlohmann/json/releases/download/v3.6.1/json.hpp"

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
ARG FDKAAC_LIB=/home/build/usr/local/lib/x86_64-linux-gnu
RUN apt-get update && apt-get install -y -q --no-install-recommends python libglib2.0-dev libboost-thread-dev libboost-system-dev liblog4cxx-dev ifelse(index(DOCKER_IMAGE,xeon-),-1,libvdpau-dev )
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
ARG FDKAAC_LIB=/home/build/usr/local/lib64
RUN yum install -y -q python-devel glib2-devel boost-devel log4cxx-devel
)dnl

# 1. Clone OWT server source code 
# 2. Clone licode source code and patch
# 3. Clone webrtc source code and patch
RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    ifelse(BUILD_DEV,enabled,mkdir ${SOURCE_DIR} &&,) cd ${SOURCE_DIR} && git clone -b ${OWT_BRANCH} ${OWTSERVER_REPO} && \
    # Get json hpp file
    wget -P /usr/include ${DOWNLOAD_JSON_LINK} ifelse(BUILD_DEV,enabled,&& cp /usr/include/json.hpp /home/build/usr/include/,) && \
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
    ifelse(index(DOCKER_IMAGE,xeon-),-1,ifelse(index(DOCKER_IMAGE,ubuntu),-1,,ln -s /opt/intel/mediasdk/lib /opt/intel/mediasdk/lib64 &&),) cd ${SERVER_PATH}/third_party/quic-lib && wget https://github.com/open-webrtc-toolkit/owt-deps-quic/releases/download/v0.1/dist.tgz && tar xzf dist.tgz ifelse(BUILD_DEV,enabled,, && \
    cd ${SERVER_PATH} && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/ssl/lib:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu):ifelse(index(DOCKER_IMAGE,xeon-),-1,/opt/intel/mediasdk/lib64,) &&  export PKG_CONFIG_PATH=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig && ifelse(index(DOCKER_IMAGE,xeon-),-1,./scripts/build.js -t mcu-all -r -c && \,./scripts/build.js -t mcu -r -c && \)
    ./scripts/pack.js -t all --install-module --no-pseudo --sample-path /home/owt-client-javascript/dist/samples/conference)
