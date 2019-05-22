ARG FFMPEG_VER="4.1.1"
ARG FFMPEG_DIR="ffmpeg-${FFMPEG_VER}"
ARG FFMPEG_SRC="${FFMPEG_DIR}.tar.bz2"
ARG FFMPEG_SRC_URL="http://ffmpeg.org/releases/${FFMPEG_SRC}"
ARG FFMPEG_SRC_MD5SUM="4a64e3cb3915a3bf71b8b60795904800"

ARG FDKAAC_VER="0.1.6"
ARG FDKAAC_SRC="fdk-aac-${FDKAAC_VER}.tar.gz"
ARG FDKAAC_SRC_URL="http://sourceforge.net/projects/opencore-amr/files/fdk-aac/${FDKAAC_SRC}/download"
ARG FDKAAC_SRC_MD5SUM="13c04c5f4f13f4c7414c95d7fcdea50f"

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libfreetype6-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q freetype-devel
)dnl

RUN wget -c ${FFMPEG_SRC_URL} && \
    rm -fr ${FFMPEG_DIR} && \
    tar xf ${FFMPEG_SRC} && \
    cd ${FFMPEG_DIR} && \
    PKG_CONFIG_PATH=/usr/lib/pkgconfig CFLAGS=-fPIC ./configure --prefix=/usr/ --enable-shared --disable-static --disable-libvpx --disable-vaapi --enable-libfreetype --enable-libfdk-aac --enable-nonfree && \
    make -j4 -s V=0 && make install && \
    make install DESTDIR="/home/build"
