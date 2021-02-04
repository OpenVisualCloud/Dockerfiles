dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2020, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`NGINX_VER',1.18.0)

ifelse(OS_NAME,ubuntu,`
define(`NGINX_BUILD_DEPS',`ca-certificates gcc libpcre3-dev libxslt1-dev make wget zlib1g-dev ifdef(`BUILD_OPENSSL',,libssl-dev)')
')

ifelse(OS_NAME,centos,`
define(`NGINX_BUILD_DEPS',`gcc libxslt-devel make pcre-devel wget zlib-devel ifdef(`BUILD_OPENSSL',,openssl-devel)')
')

define(`BUILD_NGINX',`
ARG NGINX_REPO=https://nginx.org/download/nginx-NGINX_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${NGINX_REPO} | tar xz && \
    cd nginx-NGINX_VER && \
    ./configure --prefix=/var/www \
        --sbin-path=BUILD_PREFIX/sbin/nginx --modules-path=BUILD_LIBDIR/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log \
        --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock \
        --http-log-path=/var/www/log/access.log \
        --http-client-body-temp-path=/var/www/tmp/client_body \
        --http-proxy-temp-path=/var/www/tmp/proxy \
        --http-fastcgi-temp-path=/var/www/tmp/fastcgi \
        --http-uwsgi-temp-path=/var/www/tmp/uwsgi \
        --http-scgi-temp-path=/var/www/tmp/scgi \
        --user=ifelse(OS_NAME,ubuntu,www-data,nobody) \
        --group=ifelse(OS_NAME,ubuntu,www-data,nobody) \
        --with-select_module --with-poll_module --with-threads --with-file-aio \
        --with-http_ssl_module --with-http_v2_module --with-http_realip_module \
        --with-http_addition_module --with-http_xslt_module --with-http_sub_module \
        --with-http_dav_module --with-http_flv_module --with-http_mp4_module \
        --with-http_gunzip_module --with-http_gzip_static_module \
        --with-http_auth_request_module --with-http_random_index_module \
        --with-http_secure_link_module --with-http_degradation_module \
        --with-http_slice_module --with-http_stub_status_module --with-stream \
        --with-stream_ssl_module --with-stream_realip_module \
        --with-stream_ssl_preread_module --with-pcre \
ifdef(`BUILD_NGINX_FLV',`dnl
        --add-module=../nginx-http-flv-module-NGINX_FLV_VER \
')dnl
ifdef(`BUILD_NGINX_UPLOAD',`dnl
        --add-module=../nginx-upload-module-NGINX_UPLOAD_VER \
')dnl
ifdef(`BUILD_OPENSSL',`dnl
        --with-cc-opt="-I/usr/local/ssl/include/" \
        --with-ld-opt="-L/usr/local/ssl/lib/ -Wl`,'-rpath=BUILD_PREFIX/ssl/lib" \
')dnl
    && make -j$(nproc) \
    && make install DESTDIR=BUILD_DESTDIR

# NGINX Setup
RUN mkdir -p BUILD_DESTDIR/var/www/tmp/client_body && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/proxy && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/fastcgi && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/uwsgi && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/scgi && \
    mkdir -p BUILD_DESTDIR/var/www/cache && \
ifdef(`BUILD_NGINX_FLV',`dnl
    mkdir -p BUILD_DESTDIR/var/www/dash && \
    mkdir -p BUILD_DESTDIR/var/www/hls && \
')dnl
ifdef(`BUILD_NGINX_UPLOAD',`dnl
    mkdir -p BUILD_DESTDIR/var/www/upload && \
')dnl
    mkdir -p BUILD_DESTDIR/var/www/html
')

ifelse(OS_NAME,ubuntu,`
define(`NGINX_INSTALL_DEPS',`libpcre3 libxml2 libxslt1.1 zlib1g ifdef(`BUILD_OPENSSL',,openssl)')
')

ifelse(OS_NAME,centos,`
define(`NGINX_INSTALL_DEPS',`libxml2 libxslt pcre zlib ifdef(`BUILD_OPENSSL',,openssl)')
')

REG(NGINX)

include(end.m4)dnl
