# Build opus
ARG OPUS_VER=1.2.1
ARG OPUS_REPO=https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz

define(`FFMPEG_CONFIG_OPUS',--enable-libopus )dnl
RUN wget -O - ${OPUS_REPO} | tar xz; \
    cd opus-${OPUS_VER}; \
    ./configure --prefix="/usr" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/lib64,/usr/lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE'); \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install
