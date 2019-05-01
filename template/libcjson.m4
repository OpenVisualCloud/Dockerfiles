# Build libcjson
ARG LIBCJSON_VER=1.7.11
ARG LIBCJSON_PKG_NAME=v${LIBCJSON_VER}
ARG LIBCJSON_REPO=https://github.com/DaveGamble/cJSON/archive/${LIBCJSON_PKG_NAME}.tar.gz

RUN wget -O - ${LIBCJSON_REPO} | tar xz && \
    cd cJSON-${LIBCJSON_VER} && \
    mkdir build && cd build && \
    cmake .. -DENABLE_CJSON_UTILS=On -DENABLE_CJSON_TEST=Off -DCMAKE_INSTALL_PREFIX="/usr" -DLIB_INSTALL_DIR=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    make install;
