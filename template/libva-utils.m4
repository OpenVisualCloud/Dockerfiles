# Build libva-utils
ARG LIBVA_UTILS_VER=2.4.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz

RUN wget -O - ${LIBVA_UTILS_REPO} | tar xz; \
    cd libva-utils-${LIBVA_UTILS_VER}; \
    ./autogen.sh --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu); \
    make -j8; \
    make install DESTDIR=/home/build; \
    make install;

