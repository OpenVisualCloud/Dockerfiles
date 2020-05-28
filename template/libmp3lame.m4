# Build mp3lame
ARG MP3LAME_VER=3.100
ARG MP3LAME_REPO=https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VER}/lame-${MP3LAME_VER}.tar.gz

define(`FFMPEG_CONFIG_MP3LAME',--enable-libmp3lame )dnl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${MP3LAME_REPO} | tar xz && \
    cd lame-${MP3LAME_VER} && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) --enable-defn(`BUILD_LINKAGE') --enable-nasm && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install
