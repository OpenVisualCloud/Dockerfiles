# Build libjson-c
ARG LIBJSONC_VER=0.13.1-20180305
ARG LIBJSONC_REPO=https://github.com/json-c/json-c/archive/json-c-${LIBJSONC_VER}.tar.gz

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${LIBJSONC_REPO} | tar xz && \
    cd json-c-json-c-${LIBJSONC_VER} && \
    sh autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    make -j8 && \
    make install DESTDIR="/home/build" && \
    make install;
define(`FFMPEG_CONFIG_LIBJSON_C',--enable-libjson_c )dnl
