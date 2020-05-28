# Build fdk-aac
ARG FDK_AAC_VER=v0.1.6
ARG FDK_AAC_REPO=https://github.com/mstorsjo/fdk-aac/archive/${FDK_AAC_VER}.tar.gz

define(`FFMPEG_CONFIG_FDKAAC',--enable-libfdk-aac )dnl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${FDK_AAC_REPO} | tar xz && mv fdk-aac-${FDK_AAC_VER#v} fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

