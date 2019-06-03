
FROM centos:7.5.1804 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/lib64 --disable-doc && \ 
    make -j8 && \
    make install

# Build NASM
ARG NASM_VER=2.13.03
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix="/usr" --libdir=/usr/lib64 && \
     make -j8 && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz
RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix="/usr" --libdir=/usr/lib64 && \
     make -j8 && \
     make install

#build ISPC

ARG ISPC_VER=1.9.1
ARG ISPC_REPO=https://downloads.sourceforge.net/project/ispcmirror/v${ISPC_VER}/ispc-v${ISPC_VER}-linux.tar.gz
RUN wget -O - ${ISPC_REPO} | tar xz
ENV ISPC_EXECUTABLE=/home/ispc-v${ISPC_VER}-linux/ispc

#build embree

RUN yum install -y -q tbb-devel mesa-libGL-devel

ARG EMBREE_REPO=https://github.com/embree/embree.git
ARG EMBREE_VER=df0b324
RUN git clone ${EMBREE_REPO} && \
    mkdir embree/build && \
    cd embree/build && \
    git checkout ${EMBREE_VER} && \
    cmake .. -Wno-dev -DEMBREE_TUTORIALS=OFF && \
    make -j 8 && \
    make install

#build ospray

RUN yum install -y -q libtiff-devel zlib-devel libpng-devel libjpeg-devel python-devel boost-devel

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

#build ospray

RUN yum install -y -q glfw-devel mesa-dri-drivers mpich-devel openssh-server openssh-clients

ENV PATH=$PATH:/usr/lib64/mpich/bin

ARG OSPRAY_VER=c42a885
ARG OSPRAY_REPO=https://github.com/ospray/ospray.git
RUN git clone ${OSPRAY_REPO}; \
    mkdir ospray/build; \
    cd ospray/build; \
    git checkout ${OSPRAY_VER}; \
    cmake .. -DOSPRAY_MODULE_MPI=ON -DOSPRAY_SG_OPENIMAGEIO=ON; \
    make -j 8
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ospray/build

RUN mkdir -p /var/run/sshd; \
    sed -i 's/^#Port/Port/g' /etc/ssh/sshd_config; \
    sed -i 's/^Port 22/Port 2222/g' /etc/ssh/sshd_config; \
    sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config; \
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config; \
    sed -i 's/#   Port 22/Port 2222/g' /etc/ssh/ssh_config; \
    echo 'root:ospray' |chpasswd; \
    /usr/sbin/sshd-keygen; \
    sed -i 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/g' /etc/ssh/ssh_config; \
    /usr/bin/ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa; \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#include(ospray-example_san-miguel.m4)
#include(ospray-example_xfrog.m4)

FROM build
LABEL Description="This is the base image for ospray-oiio-mpi CentOS 7.5"
LABEL Vendor="Intel Corporation"
WORKDIR /home
