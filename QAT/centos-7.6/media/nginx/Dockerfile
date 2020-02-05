
FROM centos:7.6.1810 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN yum install -y -q bzip2 make autoconf libtool git wget ca-certificates pkg-config gcc gcc-c++ bison flex patch epel-release yum-devel libcurl-devel zlib-devel;

# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix="/usr/local" --system-curl && \
    make -j8 && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz
RUN wget -O - ${AUTOMAKE_REPO} | tar xJ && \
    cd automake-${AUTOMAKE_VER} && \
    ./configure --prefix=/usr --libdir=/usr/local/lib64 --disable-doc && \ 
    make -j8 && \
    make install


#include(qat-kernel.m4)
#include(qat-driver.m4)
# Build OpenSSL for QAT
ARG QAT_OPENSSL_VER=OpenSSL_1_1_1c
ARG QAT_OPENSSL_REPO=https://github.com/openssl/openssl/archive/${QAT_OPENSSL_VER}.tar.gz

RUN wget -O - ${QAT_OPENSSL_REPO} | tar xz && mv openssl-${QAT_OPENSSL_VER} openssl && \
    cd openssl && \
    ./config --prefix=/opt/openssl --openssldir=/opt/openssl -Wl,-rpath,\${LIBRPATH} && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install; 


#include(qat-engine.m4)
#include(qat-zip.m4)
#include(nginx-qat.m4)

#FROM openvisualcloud/xeon-centos76-media-nginx:latest
#LABEL Description="This is the base image for a NGINX service"
#LABEL Vendor="Intel Corporation"
#WORKDIR /home

# Prerequisites
#include(install.pkgs.m4)
# Install
#include(install.m4)
