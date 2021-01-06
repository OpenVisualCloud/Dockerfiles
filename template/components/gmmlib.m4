include(envs.m4)
HIDE

DECLARE(`GMMLIB_VER',intel-gmmlib-20.2.5)

ifelse(OS_NAME,ubuntu,dnl
`define(`GMMLIB_BUILD_DEPS',`ca-certificates cmake g++ make wget')'
)

ifelse(OS_NAME,centos,dnl
`define(`GMMLIB_BUILD_DEPS',`cmake gcc-c++ make wget')'
)

define(`BUILD_GMMLIB',
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/GMMLIB_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${GMMLIB_REPO} | tar xz
RUN cd BUILD_HOME/gmmlib-GMMLIB_VER && mkdir build && cd build && \
  cmake -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR .. && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`GMMLIB_BUILD_PROVIDES',`libigdgmm11 libigdgmm-dev')')

REG(GMMLIB)

UNHIDE
