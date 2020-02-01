
FROM ubuntu:18.04 AS build
WORKDIR /home

# COMMON BUILD TOOLS
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev

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
    RUN apt-get install -y -q automake


#include(qat-kernel.m4)
#include(qat-driver.m4)
#include(qat-engine.m4)
#include(qat-zip.m4)
# Build OpenSSL for QAT
ARG QAT_OPENSSL_VER=OpenSSL_1_1_1c
ARG QAT_OPENSSL_REPO=https://github.com/openssl/openssl/archive/${QAT_OPENSSL_VER}.tar.gz

RUN wget -O - ${QAT_OPENSSL_REPO} | tar xz && mv openssl-${QAT_OPENSSL_VER} openssl && \
    cd openssl && \
    ./config --prefix=/opt/openssl --openssldir=/opt/openssl -Wl,-rpath,\${LIBRPATH} && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install; 


# Build NGINX Asynchronous Mode
ARG NGINX_QAT_VER=v0.4.0
ARG NGINX_QAT_REPO=https://github.com/intel/asynch_mode_nginx/archive/${NGINX_QAT_VER}.tar.gz

RUN apt-get update && apt-get install -y -q --no-install-recommends libssl-dev libpcre3-dev zlib1g-dev libxslt1-dev

RUN wget -O - ${NGINX_QAT_REPO} | tar xz && cd asynch_mode_nginx* && \
    ./configure --add-dynamic-module=modules/nginx_qatzip_module --add-dynamic-module=modules/nginx_qat_module --with-cc-opt="-DNGX_SECURE_MEM -I/opt/openssl/include -Wno-error=deprecated-declarations" --with-ld-opt="-L/opt/openssl/lib -L/opt/qat/lib -lqatzip -lz" --prefix=/var/www --sbin-path=/usr/local/sbin/nginx --modules-path=/usr/local/lib/x86_64-linux-gnu/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock --http-log-path=/var/www/log/access.log --http-client-body-temp-path=/var/www/tmp/client_body --http-proxy-temp-path=/var/www/tmp/proxy --http-fastcgi-temp-path=/var/www/tmp/fastcgi --http-uwsgi-temp-path=/var/www/tmp/uwsgi --http-scgi-temp-path=/var/www/tmp/scgi --user=www-data --group=www-data --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-pcre  && \
    make -j8 && \
    make install DESTDIR=/home/build;

# NGINX Setup
COPY *.conf /home/build/etc/nginx
RUN mkdir -p /home/build/var/www/tmp/client_body && \
    mkdir -p /home/build/var/www/tmp/proxy && \
    mkdir -p /home/build/var/www/tmp/fastcgi && \
    mkdir -p /home/build/var/www/tmp/uwsgi && \
    mkdir -p /home/build/var/www/tmp/scgi && \
    mkdir -p /home/build/var/www/cache;



#FROM openvisualcloud/xeon-ubuntu1804-media-ffmpeg:latest
#LABEL Description="This is the base image for a NGINX+RTMP service"
#LABEL Vendor="Intel Corporation"
#WORKDIR /home

# Prerequisites
#include(install.pkgs.m4)
# Install
#include(install.m4)
