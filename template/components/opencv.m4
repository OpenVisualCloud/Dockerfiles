include(envs.m4)
HIDE

DECLARE(`OPENCV_VER',4.4.0)

ifelse(OS_NAME,ubuntu,dnl
`define(`OPENCV_BUILD_DEPS',`ca-certificates cmake gcc g++ wget')'
)

ifelse(OS_NAME,centos,dnl
`define(`OPENCV_BUILD_DEPS',`cmake gcc gcc-c++ wget')'
)

define(`OPENCV_INSTALL_DEPS',`')

define(`BUILD_OPENCV',
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/OPENCV_VER.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${OPENCV_REPO} | tar xz
# TODO: file a bug against opencv since they do not accept full libdir
RUN cd BUILD_HOME/opencv-OPENCV_VER && mkdir build && cd build && \
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=patsubst(BUILD_LIBDIR,BUILD_PREFIX/) \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    .. && \
  make -j "$(nproc)" && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
)

REG(OPENCV)

UNHIDE
