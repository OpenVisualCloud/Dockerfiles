dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
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

DECLARE(`QAT_NGINX_VER',v0.4.0)

ifelse(OS_NAME,ubuntu,`
define(`QAT_NGINX_BUILD_DEPS',`wget ca-certificates libpcre3-dev zlib1g-dev libxslt1-dev ifdef(`BUILD_OPENSSL',,libssl-dev)')
define(`QAT_NGINX_INSTALL_DEPS',`libxml2 libpcre3 zlib1g libxslt1.1 ifdef(`BUILD_OPENSSL',,libssl1.1)')
')

ifelse(OS_NAME,centos,`
define(`QAT_NGINX_BUILD_DEPS',`wget pcre-devel zlib-devel libxslt-devel ifdef(`BUILD_OPENSSL',,openssl-devel)')
define(`QAT_NGINX_INSTALL_DEPS',`pcre zlib libxslt ifdef(`BUILD_OPENSSL',,openssl11)')
')

define(`BUILD_QAT_NGINX',`
ARG QAT_NGINX_REPO=https://github.com/intel/asynch_mode_nginx/archive/QAT_NGINX_VER.tar.gz
RUN wget -O - ${QAT_NGINX_REPO} | tar xz && cd asynch_mode_nginx* && \
    ./configure --with-ld-opt="-Wl,-rpath=BUILD_PREFIX/ssl/lib,-rpath=/opt/intel/QATengine/lib,-rpath=/opt/intel/QATzip/lib64,-rpath=/opt/intel/QAT/build -L`'BUILD_PREFIX/ssl/lib -L/opt/intel/QATzip/lib64 -lqatzip -lz" \
        --with-cc-opt="-DNGX_SECURE_MEM -I`'BUILD_PREFIX/ssl/include -I/opt/intel/QATzip/include -Wno-error=deprecated-declarations" \
        --add-dynamic-module=modules/nginx_qatzip_module \
        --add-dynamic-module=modules/nginx_qat_module \
        --prefix=/var/www \
        --sbin-path=BUILD_PREFIX/sbin/nginx \
        --modules-path=/var/www/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/www/log/error.log \
        --pid-path=/var/www/nginx.pid \
        --lock-path=/var/www/nginx.lock \
        --http-log-path=/var/www/log/access.log \
        --http-client-body-temp-path=/var/www/tmp/client_body \
        --http-proxy-temp-path=/var/www/tmp/proxy \
        --http-fastcgi-temp-path=/var/www/tmp/fastcgi \
        --http-uwsgi-temp-path=/var/www/tmp/uwsgi \
        --http-scgi-temp-path=/var/www/tmp/scgi \
        --user=ifelse(OS_NAME,ubuntu,www-data,nobody) \
        --group=ifelse(OS_NAME,ubuntu,www-data,nobody) \
        --with-select_module --with-poll_module \
        --with-threads --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-stream \
        --with-stream_ssl_module \
ifdef(`BUILD_NGINX_FLV',`dnl
        --add-module=BUILD_HOME/nginx-http-flv-module-NGINX_FLV_VER \
')dnl
ifdef(`BUILD_NGINX_UPLOAD',`dnl
        --add-module=BUILD_HOME/nginx-upload-module-NGINX_UPLOAD_VER \
')dnl
    && make -j8 && \
    make install DESTDIR=BUILD_DESTDIR

# NGINX Setup
COPY *.conf BUILD_DESTDIR/etc/nginx/
RUN mkdir -p BUILD_DESTDIR/var/www/tmp/client_body && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/proxy && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/fastcgi && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/uwsgi && \
    mkdir -p BUILD_DESTDIR/var/www/tmp/scgi && \
    mkdir -p BUILD_DESTDIR/var/www/cache && \
    mkdir -p BUILD_DESTDIR/var/www/dash && \
    mkdir -p BUILD_DESTDIR/var/www/hls && \
    mkdir -p BUILD_DESTDIR/var/www/upload && \
    mkdir -p BUILD_DESTDIR/var/www/html && \
    touch BUILD_DESTDIR/var/www/html/index.html;
')

define(`QAT_NGINX_ENV_VARS',`dnl
ENV OPENSSL_ENGINES=BUILD_PREFIX/ssl/lib/engines-1.1
')

REG(QAT_NGINX)

include(end.m4)dnl
