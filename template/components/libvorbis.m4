include(envs.m4)
HIDE

include(libogg.m4)

DECLARE(`LIBVORBIS_VER',1.3.7)

ifelse(OS_NAME,ubuntu,`
define(`LIBVORBIS_BUILD_DEPS',ca-certificates wget make autoconf automake)
')

ifelse(OS_NAME,centos,`
define(`LIBVORBIS_BUILD_DEPS',wget make autoconf diffutils automake)
')

define(`BUILD_LIBVORBIS',`
ARG LIBVORBIS_REPO=https://downloads.xiph.org/releases/vorbis/libvorbis-LIBVORBIS_VER.tar.gz

RUN cd BUILD_HOME && \
    wget -O - ${LIBVORBIS_REPO} | tar xz && \
    cd libvorbis-LIBVORBIS_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBVORBIS_BUILD_PROVIDES',libvorbis)

REG(LIBVORBIS)

UNHIDE
