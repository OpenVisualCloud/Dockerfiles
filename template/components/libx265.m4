include(envs.m4)
HIDE

include(yasm.m4)

DECLARE(`LIBX265_VER',3.3)

ifelse(OS_NAME,ubuntu,`
define(`LIBX265_BUILD_DEPS',libnuma-dev cmake make)
')

ifelse(OS_NAME,centos,`
define(`LIBX265_BUILD_DEPS',cmake make numactl-devel libpciaccess-devel)
')

define(`BUILD_LIBX265',`
ARG LIBX265_REPO=https://github.com/videolan/x265/archive/LIBX265_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBX265_REPO} | tar xz && \
    cd x265-LIBX265_VER/build/linux && \
    cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DLIB_INSTALL_DIR=BUILD_LIBDIR ../../source && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBX265_BUILD_PROVIDES',libx265)

ifelse(OS_NAME,ubuntu,`
define(`LIBX265_INSTALL_DEPS',libnuma1)
')

ifelse(OS_NAME,centos,`
define(`LIBX265_INSTALL_DEPS',numactl-libs libpciaccess)
')

REG(LIBX265)

UNHIDE
