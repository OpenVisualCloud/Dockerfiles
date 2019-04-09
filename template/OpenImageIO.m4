#build ospray

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libtiff-dev zlib1g-dev libpng-dev libjpeg-dev libboost-python-dev libboost-filesystem-dev libboost-thread-dev
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel
)dnl

ARG OpenEXR_VER=0ac2ea3
ARG OpenEXR_REPO=https://github.com/openexr/openexr.git
RUN git clone ${OpenEXR_REPO}; \
    mkdir openexr/build; \
    cd openexr/build; \
    git checkout ${OpenEXR_VER}; \
    cmake ..; \
    make -j 8; \
    make install

ARG OpenImageIO_VER=5daa9a1
ARG OpenImageIO_REPO=https://github.com/OpenImageIO/oiio.git
RUN git clone ${OpenImageIO_REPO}; \
    mkdir oiio/build; \
    cd oiio/build; \
    git checkout ${OpenImageIO_VER}; \
    cmake ..; \
    make -j 8; \
    make install
