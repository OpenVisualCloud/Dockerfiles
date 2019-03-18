#build embree

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends libtbb-dev libgl1-mesa-dev 
)dnl
ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q tbb-devel mesa-libGL-devel
)dnl

ARG EMBREE_REPO=https://github.com/embree/embree.git
ARG EMBREE_VER=df0b324
RUN git clone ${EMBREE_REPO}; \
    mkdir embree/build; \
    cd embree/build; \
    git checkout ${EMBREE_VER}; \
    cmake .. -Wno-dev -DEMBREE_TUTORIALS=OFF; \
    make -j 8; \
    make install
