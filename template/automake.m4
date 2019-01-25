# Install automake
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz

RUN wget -O - ${AUTOMAKE_REPO} | tar xJ; \
    cd automake-${AUTOMAKE_VER}; \
    ./configure --prefix=/usr --libdir=/usr/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu) --disable-doc; \ 
    make -j8; \
    make install

