include(envs.m4)
HIDE

DECLARE(`LIBVA2_UTILS_VER',2.8.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`LIBVA2_UTILS_BUILD_DEPS',`automake ca-certificates gcc g++ libdrm-dev libtool libva-dev make pkg-config wget')'
)

ifelse(OS_NAME,centos,dnl
`define(`LIBVA2_UTILS_BUILD_DEPS',`automake gcc gcc-c++ libdrm-devel libtool make pkg-config wget which')'
`ifdef(`BUILD_LIBVA2',,`include(libva2.m4)')'
)

define(`LIBVA2_UTILS_INSTALL_DEPS',`')

define(`BUILD_LIBVA2_UTILS',
ARG LIBVA2_UTILS_REPO=https://github.com/intel/libva-utils/archive/LIBVA2_UTILS_VER.tar.gz
RUN cd BUILD_HOME && wget -O - ${LIBVA2_UTILS_REPO} | tar xz
RUN cd BUILD_HOME/libva-utils-LIBVA2_UTILS_VER && \
  ./autogen.sh --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`LIBVA2_UTILS_BUILD_PROVIDES',vainfo)')
)

define(`ENV_VARS_LIBVA2_UTILS',
ENV LIBVA_DRIVERS_PATH=BUILD_LIBDIR/dri
ENV LIBVA_DRIVER_NAME=iHD
)

REG(LIBVA2_UTILS)

UNHIDE
