# Build vorbis
ARG VORBIS_VER=1.3.6
ARG VORBIS_REPO=https://github.com/xiph/vorbis/archive/v${VORBIS_VER}.tar.gz

define(`FFMPEG_CONFIG_VORBIS',--enable-libvorbis )dnl
RUN wget -O - ${VORBIS_REPO} | tar xz && \
    cd vorbis-${VORBIS_VER} && \
    ./autogen.sh && \
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install
