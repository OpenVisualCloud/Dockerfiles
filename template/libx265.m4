# Build x265
ARG X265_VER=2.9
ARG X265_REPO=https://github.com/videolan/x265/archive/${X265_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,
RUN  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libnuma-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,
RUN  yum install -y -q numactl-devel libpciaccess-devel
)dnl

define(`FFMPEG_CONFIG_X265',--enable-libx265 )dnl
RUN  wget -O - ${X265_REPO} | tar xz && mv x265-${X265_VER} x265 && \
     cd x265/build/linux && \
     cmake -DBUILD_SHARED_LIBS=ifelse(BUILD_LINKAGE,shared,ON,OFF) -DENABLE_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) ../../source && \
     make -j8 && \
     make install DESTDIR="/home/build" && \
     make install
