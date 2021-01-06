include(envs.m4)
HIDE

include(nasm.m4)

DECLARE(`LIBX264_VER',stable)

ifelse(OS_NAME,ubuntu,`
define(`LIBX264_BUILD_DEPS',git cmake make autoconf)
')

ifelse(OS_NAME,centos,`
define(`LIBX264_BUILD_DEPS',git cmake make autoconf diffutils)
')

define(`BUILD_LIBX264',`
ARG LIBX264_REPO=https://github.com/mirror/x264
RUN cd BUILD_HOME && \
    git clone ${LIBX264_REPO} -b LIBX264_VER --depth 1 && \
    cd x264 && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBX264_BUILD_PROVIDES',libx264)

REG(LIBX264)

UNHIDE
