# Build libdrm
ARG LIBDRM_VER=2.4.96
ARG LIBDRM_REPO=https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libpciaccess-dev	&& \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q libpciaccess-devel
)dnl

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${LIBDRM_REPO} | tar xz && \
    cd libdrm-${LIBDRM_VER} && \
    ./configure --prefix=/usr/local --libdir=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install ;

define(`INSTALL_PKGS_LIBDRM',libpciaccess )dnl
