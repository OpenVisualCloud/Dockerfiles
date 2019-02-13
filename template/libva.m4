# Build libva
ARG LIBVA_VER=2.3.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libx11-dev xorg-dev libgl1-mesa-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q libX11-devel mesa-libGL-devel which libdrm-devel
)dnl

RUN wget -O - ${LIBVA_REPO} | tar xz; \
    cd libva-${LIBVA_VER}; \
    ./autogen.sh --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu); \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install;

define(`INSTALL_PKGS_LIBVA',mesa-dri-drivers mesa-libGL )dnl
