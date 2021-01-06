include(envs.m4)
include(libva2.m4)
HIDE

DECLARE(`MSDK_VER',intel-mediasdk-20.2.1)
DECLARE(`MSDK_BUILD_SAMPLES',no)

ifelse(OS_NAME,ubuntu,dnl
`define(`MSDK_BUILD_DEPS',`ca-certificates gcc g++ make cmake pkg-config wget')'
)

ifelse(OS_NAME,centos,dnl
`define(`MSDK_BUILD_DEPS',`cmake gcc gcc-c++ make pkg-config wget')'
)

define(`BUILD_MSDK',dnl
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/MSDK_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${MSDK_REPO} | tar xz
RUN cd BUILD_HOME/MediaSDK-MSDK_VER && \
  mkdir -p build && cd build && \
  cmake \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR \
    -DBUILD_SAMPLES=MSDK_BUILD_SAMPLES \
    -DBUILD_TUTORIALS=OFF \
    .. && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

ifelse(OS_NAME,ubuntu,dnl
`define(`BUILD_PROVIDES',`libmfx1 libmfx-dev libmfx-tools')')

REG(MSDK)

UNHIDE
