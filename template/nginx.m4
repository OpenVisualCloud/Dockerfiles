# Build nginx & nginx-http-flv
ARG NGINX_VER=1.16.1
ARG NGINX_REPO=https://nginx.org/download/nginx-${NGINX_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libssl-dev libpcre3-dev zlib1g-dev libxslt1-dev
)ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q openssl-devel pcre2-devel zlib-devel libxslt-devel
)dnl

RUN wget -O - ${NGINX_REPO} | tar xz && \
    cd nginx-${NGINX_VER} && \
    ./configure --prefix=/var/www --sbin-path=/usr/local/sbin/nginx --modules-path=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock --http-log-path=/var/www/log/access.log --http-client-body-temp-path=/var/www/tmp/client_body --http-proxy-temp-path=/var/www/tmp/proxy --http-fastcgi-temp-path=/var/www/tmp/fastcgi --http-uwsgi-temp-path=/var/www/tmp/uwsgi --http-scgi-temp-path=/var/www/tmp/scgi --user=ifelse(index(DOCKER_IMAGE,ubuntu),-1,nobody,www-data) --group=ifelse(index(DOCKER_IMAGE,ubuntu),-1,nobody,www-data) --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_ssl_preread_module --with-pcre defn(`NGINX_HTTP_FLV_MODULE',`NGINX_UPLOAD_MODULE') && \
    make -j8 && \
    make install DESTDIR=/home/build;

# NGINX Setup
COPY nginx.conf /home/build/etc/nginx
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

define(`INSTALL_PKGS_NGINX',ifelse(index(DOCKER_IMAGE,ubuntu),-1,openssl-libs pcre2 zlib libxslt libxml2 ,libxml2 libssl1.0.0 libpcre3 zlib1g libxslt1.1 ))dnl
define(`INSTALL_NGINX',dnl
CMD /usr/local/sbin/nginx
)dnl
