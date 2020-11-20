include(envs.m4)
HIDE

DECLARE(`LIBOGG_VER',1.3.4)

ifelse(OS_NAME,ubuntu,`
define(`LIBOGG_BUILD_DEPS',ca-certificates wget make autoconf automake g++)
')

ifelse(OS_NAME,centos,`
define(`LIBOGG_BUILD_DEPS',wget make autoconf diffutils automake gcc-c++)
')

define(`BUILD_LIBOGG',`
ARG LIBOGG_REPO=https://downloads.xiph.org/releases/ogg/libogg-LIBOGG_VER.tar.gz

RUN cd BUILD_HOME && \
    wget -O - ${LIBOGG_REPO} | tar xz && \
    cd libogg-LIBOGG_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBOGG_BUILD_PROVIDES',libogg)

REG(LIBOGG)

UNHIDE
