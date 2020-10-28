# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-KBL-2019-R1-HF1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz


RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK && \
    mkdir -p MediaSDK/build && \
    cd MediaSDK/build && \
    export PKG_CONFIG_PATH="/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/pkgconfig" && \
    cmake ifelse(index(DOCKER_IMAGE,service),-1, -DCMAKE_INSTALL_PREFIX=/usr/local, -DCMAKE_INSTALL_PREFIX=/opt/intel/mediasdk) -DCMAKE_INSTALL_INCLUDEDIR=include -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
ifelse(index(DOCKER_IMAGE,-dev),-1,dnl
    rm -rf /home/build/usr/samples && \
    rm -rf /home/build/usr/plugins && \
    rm -rf /home/build/usr/local/samples && \
    rm -rf /home/build/usr/local/plugins && \
)dnl
    make install;
