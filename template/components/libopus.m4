include(envs.m4)
HIDE

DECLARE(`LIBOPUS_VER',1.3.1)

ifelse(OS_NAME,ubuntu,`
define(`LIBOPUS_BUILD_DEPS',ca-certificates wget autoconf libtool make)
')

ifelse(OS_NAME,centos,`
define(`LIBOPUS_BUILD_DEPS',wget autoconf libtool make)
')

define(`BUILD_LIBOPUS',`
ARG LIBOPUS_REPO=https://archive.mozilla.org/pub/opus/opus-LIBOPUS_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${LIBOPUS_REPO} | tar xz && \
    cd opus-LIBOPUS_VER && \
    ./configure --prefix=BUILD_PREFIX --libdir=BUILD_LIBDIR --enable-shared && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBOPUS_BUILD_PROVIDES',libopus)

REG(LIBOPUS)

UNHIDE
