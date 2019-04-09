# Build librdkafka
ARG LIBRDKAFKA_VER=0.11.6
ARG FILE_NAME=v${LIBRDKAFKA_VER}
ARG LIBRDKAFKA_REPO=https://github.com/edenhill/librdkafka/archive/${FILE_NAME}.tar.gz

RUN wget -O - ${LIBRDKAFKA_REPO} | tar xz && \
    cd librdkafka-${LIBRDKAFKA_VER} && \
    ./configure --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install;
define(`FFMPEG_CONFIG_LIBRDKAFKA',--enable-librdkafka )dnl
