include(envs.m4)
include(libva2.m4)
include(gmmlib.m4)
HIDE

DECLARE(`MEDIA_DRIVER_VER',intel-media-20.2.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`MEDIA_DRIVER_BUILD_DEPS',`ca-certificates cmake g++ libpciaccess-dev make pkg-config wget')'
)

ifelse(OS_NAME,centos,dnl
`define(`MEDIA_DRIVER_BUILD_DEPS',`cmake gcc-c++ libpciaccess-devel make pkg-config wget')'
)

define(`BUILD_MEDIA_DRIVER',
ARG MEDIA_DRIVER_REPO=https://github.com/intel/media-driver/archive/MEDIA_DRIVER_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${MEDIA_DRIVER_REPO} | tar xz
RUN cd BUILD_HOME/media-driver-MEDIA_DRIVER_VER && mkdir build && cd build && \
  cmake -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR .. && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`MEDIA_DRIVER_BUILD_PROVIDES',`libigfxcmrt-dev libigfxcmrt7 intel-media-va-driver intel-media-va-driver-non-free')')

REG(MEDIA_DRIVER)

UNHIDE
