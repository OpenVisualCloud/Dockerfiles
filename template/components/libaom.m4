include(envs.m4)
HIDE

include(nasm.m4)

DECLARE(`LIBAOM_VER',2.0.0)

ifelse(OS_NAME,ubuntu,`
define(`LIBAOM_BUILD_DEPS',git cmake make)
')

ifelse(OS_NAME,centos,`
define(`LIBAOM_BUILD_DEPS',git cmake3 make)
')

define(`BUILD_LIBAOM',`
ARG LIBAOM_REPO=https://aomedia.googlesource.com/aom
RUN cd BUILD_HOME && \
    git clone ${LIBAOM_REPO} -b v`'LIBAOM_VER --depth 1 && \
    cd aom/build && \
    ifelse(OS_NAME,centos,cmake3,cmake) -DBUILD_SHARED_LIBS=ON -DENABLE_NASM=ON -DENABLE_TESTS=OFF -DENABLE_DOCS=OFF -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX -DCMAKE_INSTALL_LIBDIR=patsubst(BUILD_LIBDIR,BUILD_PREFIX/) .. && \
    make -j$(nproc) && \
    make install DESTDIR=BUILD_DESTDIR && \
    make install
')

define(`LIBAOM_BUILD_PROVIDES',libaom)

REG(LIBAOM)

UNHIDE
