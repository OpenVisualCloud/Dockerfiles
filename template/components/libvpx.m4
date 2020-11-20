include(envs.m4)
HIDE

include(nasm.m4)

DECLARE(`LIBVPX_VER',1.8.2)

ifelse(OS_NAME,ubuntu,`
define(`LIBVPX_BUILD_DEPS',git cmake make autoconf)
')

ifelse(OS_NAME,centos,`
define(`LIBVPX_BUILD_DEPS',git cmake make autoconf diffutils)
')

define(`BUILD_LIBVPX',`
ARG LIBVPX_REPO=https://chromium.googlesource.com/webm/libvpx.git
RUN cd BUILD_HOME && \
    git clone ${LIBVPX_REPO} -b v`'LIBVPX_VER --depth 1 && \
    cd libvpx && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBVPX_BUILD_PROVIDES',libvpx)

REG(LIBVPX)

UNHIDE
