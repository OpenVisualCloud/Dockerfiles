# Build libnice
ARG NICE_VER="0.1.4"
ARG NICE_REPO=http://nice.freedesktop.org/releases/libnice-${NICE_VER}.tar.gz
ARG LIBNICE_PATCH_VER="4.3.1"
ARG LIBNICE_PATCH_REPO=https://github.com/open-webrtc-toolkit/owt-server/archive/v${LIBNICE_PATCH_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q glib2-devel
)dnl

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${NICE_REPO} | tar xz && \
    cd libnice-${NICE_VER} && \
    wget -O - ${LIBNICE_PATCH_REPO} | tar xz  && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-agentlock.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-agentlock-plus.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-removecandidate.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-keepalive.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-startcheck.patch && \
    patch -p1 < owt-server-${LIBNICE_PATCH_VER}/scripts/patches/libnice014-closelock.patch && \
    ./configure --prefix="/usr/local" --libdir=ifelse(index(DOCKER_IMAGE,ubuntu),-1,/usr/local/lib64,/usr/local/lib/x86_64-linux-gnu) && \
    make -s V= && \
    make install

