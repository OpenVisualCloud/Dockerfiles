# Build Intel(R) Media SDK
ARG MSDK_VER=MSS-2018-R2.1
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz

RUN wget -O - ${MSDK_REPO} | tar xz && mv MediaSDK-${MSDK_VER} MediaSDK; \
    mkdir -p MediaSDK/build; \
    cd MediaSDK/build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_INCLUDEDIR=include/mfx -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev ..; \
    make -j8; \
    make install DESTDIR=/home/build; \
ifelse(index(DOCKER_IMAGE,-dev),-1,dnl
    rm -rf /home/build/usr/samples; \
    rm -rf /home/build/usr/plugins; \
)dnl
    make install;
