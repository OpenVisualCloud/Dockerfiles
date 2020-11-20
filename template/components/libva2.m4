include(envs.m4)
HIDE

DECLARE(`LIBVA2_VER',2.8.0)
DECLARE(`LIBVA2_X11',true)

define(`LIBVA2_X11_BUILD',dnl
ifelse(LIBVA2_X11,true,`ifelse(
OS_NAME,ubuntu,libx11-dev libxext-dev libxfixes-dev,
OS_NAME,centos,libX11-devel libXfixes-devel libXext-devel)'))dnl

define(`LIBVA2_X11_INSTALL',dnl
ifelse(LIBVA2_X11,true,`ifelse(
OS_NAME,ubuntu,libx11-6 libxext6 libxfixes3,
OS_NAME,centos,libX11 libXfixes libXext)'))dnl

ifelse(OS_NAME,ubuntu,dnl
`define(`LIBVA2_BUILD_DEPS',`automake ca-certificates gcc libdrm-dev libtool make pkg-config wget LIBVA2_X11_BUILD')'
`define(`LIBVA2_INSTALL_DEPS',`libdrm2 LIBVA2_X11_INSTALL')'
)

ifelse(OS_NAME,centos,dnl
`define(`LIBVA2_BUILD_DEPS',`automake gcc libdrm-devel libtool make pkg-config wget which LIBVA2_X11_BUILD')'
`define(`LIBVA2_INSTALL_DEPS',`libdrm LIBVA2_X11_INSTALL')'
)

define(`BUILD_LIBVA2',
ARG LIBVA2_REPO=https://github.com/intel/libva/archive/LIBVA2_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${LIBVA2_REPO} | tar xz
RUN cd BUILD_HOME/libva-LIBVA2_VER && \
  ./autogen.sh --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`LIBVA2_BUILD_PROVIDES',`libva2 libva-dev')')

REG(LIBVA2)

UNHIDE
