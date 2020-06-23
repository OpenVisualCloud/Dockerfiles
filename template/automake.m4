# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
ifelse(index(DOCKER_IMAGE,ubuntu),-1,`dnl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/local/lib64 --disable-doc && \ 
    make -j8 && \
    make install'
,dnl
    RUN apt-get install -y -q --no-install-recommends automake	&& \
        apt-get clean	&& \
        rm -rf /var/lib/apt/lists/*
)dnl
