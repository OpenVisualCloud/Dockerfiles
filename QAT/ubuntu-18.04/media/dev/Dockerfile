
FROM ubuntu:18.04 AS build
WORKDIR /home

# COMMON BUILD TOOLS
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3009
RUN apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev

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
    RUN apt-get install -y -q --no-install-recommends automake	&& \
        apt-get clean	&& \
        rm -rf /var/lib/apt/lists/*


# Build nginx-http-flv
ARG NGINX_HTTP_FLV_VER=v1.2.7
ARG NGINX_HTTP_FLV_REPO=https://github.com/winshining/nginx-http-flv-module.git

ARG NGINX_HTTP_FLV_PATCHES_RELEASE_VER=0.2
ARG NGINX_HTTP_FLV_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}.tar.gz
ARG NGINX_HTTP_FLV_PATCHES_PATH=/home/CDN-${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}
RUN wget -O - ${NGINX_HTTP_FLV_PATCHES_RELEASE_URL} | tar xz

RUN git clone ${NGINX_HTTP_FLV_REPO} && \
    cd nginx-http-flv-module && \
    git checkout ${NGINX_HTTP_FLV_VER} && \
    mkdir -p /home/build/var/www/html && \
    cp -f stat.xsl /home/build/var/www/html && \
    find ${NGINX_HTTP_FLV_PATCHES_PATH}/Nginx-HTTP-FLV_patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;

# Build nginx-upload-module
ARG NGINX_UPLOAD_VER=2.3.0
ARG NGINX_UPLOAD_REPO=https://github.com/fdintino/nginx-upload-module/archive/${NGINX_UPLOAD_VER}.tar.gz

RUN wget -O - ${NGINX_UPLOAD_REPO} | tar xz

# load qat
ADD qat.tar.gz /home/build/
RUN mkdir -p /opt/intel /home/build/opt/intel && \
    ln -s /home/build/opt/intel/QAT /opt/intel/QAT

# Build QATZip
ARG QATZIP_VER=v1.0.1
ARG QATZIP_REPO=https://github.com/intel/QATzip/archive/${QATZIP_VER}.tar.gz

RUN wget -O - ${QATZIP_REPO} | tar xz && \
    cd QATzip* && \
    /bin/bash ./configure LDFLAGS="-Wl,-rpath=/opt/intel/QAT/build" --with-ICP_ROOT=/opt/intel/QAT --prefix=/opt/intel/QATzip && \
    make -j8 && \
    make install && \
    (cd /opt/intel/QATzip/lib64 && ln -s libqatzip.so libqatzip.so.1) && \
    tar cf - /opt/intel/QATzip | (cd /home/build; tar xf -)

# Build OpenSSL for QAT
ARG QAT_OPENSSL_VER=OpenSSL_1_1_1c
ARG QAT_OPENSSL_REPO=https://github.com/openssl/openssl/archive/${QAT_OPENSSL_VER}.tar.gz

RUN wget -O - ${QAT_OPENSSL_REPO} | tar xz && mv openssl-${QAT_OPENSSL_VER} openssl && \
    cd openssl && \
    ./config --prefix=/opt/openssl --openssldir=/opt/openssl -Wl,-rpath,"\${LIBRPATH}" && \
    make -j8 && \
    make install && \
    echo

# Build QAT Engine
ARG QAT_ENGINE_VER=v0.5.42
ARG QAT_ENGINE_REPO=https://github.com/intel/QAT_Engine/archive/${QAT_ENGINE_VER}.tar.gz

RUN wget -O - ${QAT_ENGINE_REPO} | tar xz && \
    cd QAT_Engine* && \
    ./autogen.sh && \
    ./configure --with-qat_dir=/opt/intel/QAT --with-openssl_dir=/home/openssl --with-openssl_install_dir=/opt/openssl --enable-upstream_driver --enable-usdm --prefix=/opt/intel/QATengine --enable-qat_debug && \
    PERL5LIB=/home/openssl make -j8 && \
    PERL5LIB=/home/openssl make install && \
    tar cf - /opt/openssl | (cd /home/build && tar xf -)



# Build NGINX Asynchronous Mode
ARG NGINX_QAT_VER=v0.4.0
ARG NGINX_QAT_REPO=https://github.com/intel/asynch_mode_nginx/archive/${NGINX_QAT_VER}.tar.gz

RUN apt-get update && apt-get install -y -q --no-install-recommends libpcre3-dev zlib1g-dev libxslt1-dev

RUN wget -O - ${NGINX_QAT_REPO} | tar xz && cd asynch_mode_nginx* && \
    ./configure --with-ld-opt="-Wl,-rpath=/opt/openssl/lib,-rpath=/opt/intel/QATengine/lib,-rpath=/opt/intel/QATzip/lib64,-rpath=/opt/intel/QAT/build -L/opt/openssl/lib -L/opt/intel/QATzip/lib64 -lqatzip -lz" --with-cc-opt="-DNGX_SECURE_MEM -I/opt/openssl/include -I/opt/intel/QATzip/include -Wno-error=deprecated-declarations" --add-dynamic-module=modules/nginx_qatzip_module --add-dynamic-module=modules/nginx_qat_module --prefix=/var/www --sbin-path=/usr/local/sbin/nginx --modules-path=/var/www/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock --http-log-path=/var/www/log/access.log --http-client-body-temp-path=/var/www/tmp/client_body --http-proxy-temp-path=/var/www/tmp/proxy --http-fastcgi-temp-path=/var/www/tmp/fastcgi --http-uwsgi-temp-path=/var/www/tmp/uwsgi --http-scgi-temp-path=/var/www/tmp/scgi --user=www-data --group=www-data --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --add-module=../nginx-http-flv-module --add-module=../nginx-upload-module-${NGINX_UPLOAD_VER}  && \
    make -j8 && \
    make install DESTDIR=/home/build

# NGINX Setup
COPY *.conf /home/build/etc/nginx/
RUN mkdir -p /home/build/var/www/tmp/client_body && \
    mkdir -p /home/build/var/www/tmp/proxy && \
    mkdir -p /home/build/var/www/tmp/fastcgi && \
    mkdir -p /home/build/var/www/tmp/uwsgi && \
    mkdir -p /home/build/var/www/tmp/scgi && \
    mkdir -p /home/build/var/www/cache && \
    mkdir -p /home/build/var/www/dash && \
    mkdir -p /home/build/var/www/hls && \
    mkdir -p /home/build/var/www/upload && \
    mkdir -p /home/build/var/www/html && \
    touch /home/build/var/www/html/index.html;


# Generate a self-certificate for testing purpose
RUN mkdir -p /home/build/etc/nginx && \
    printf "US\nOR\nPortland\nOregon\nData Center Group\nIntel Corporation\n%s\nnobody@intel.com\n" "$(hostname)" | /opt/openssl/bin/openssl req -x509 -nodes -days 30 -newkey rsa:4096 -keyout /home/build/etc/nginx/cert.key -out /home/build/etc/nginx/cert.crt && \
    chmod 640 /home/build/etc/nginx/cert.key && \
    chmod 644 /home/build/etc/nginx/cert.crt



FROM openvisualcloud/xeon-ubuntu1804-media-dev:latest
LABEL Description="This is the media development image"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    apt-get update && apt-get install -y -q --no-install-recommends libxml2 libssl1.0.0 libpcre3 zlib1g libxslt1.1 vim && \
    apt-get clean	&& \
    rm -rf /var/lib/apt/lists/*
# Install
COPY --from=build /home/build /
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib/x86_64-linux-gnu
CMD ["/usr/local/sbin/nginx"]
VOLUME /etc/nginx /var/www/html /var/www/tmp/client_body /var/www/tmp/proxy /var/www/tmp/fastcgi /var/www/tmp/uwsgi /var/www/tmp/scgi /var/www/cache /var/www/dash /var/www/hls
ENV OPENSSL_ENGINES=/opt/openssl/lib/engines-1.1
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64



