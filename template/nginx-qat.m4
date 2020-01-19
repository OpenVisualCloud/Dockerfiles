# Build NGINX Asynchronous Mode
ARG NGINX_QAT_VER=v0.4.0
ARG NGINX_QAT_REPO=https://github.com/intel/asynch_mode_nginx/archive/${NGINX_QAT_VER}.tar.gz

ifelse(index(DOCKER_IMAGE,ubuntu),-1,,dnl
RUN apt-get update && apt-get install -y -q --no-install-recommends libssl-dev libpcre3-dev zlib1g-dev libxslt1-dev
)ifelse(index(DOCKER_IMAGE,centos),-1,,dnl
RUN yum install -y -q openssl-devel pcre2-devel zlib-devel libxslt-devel
)dnl

RUN wget -O - ${NGINX_QAT_REPO} | tar xz && mv async_mode_nginx-${NGINX_QAT_VER} asynch_mode_nginx && \
    cd asynch_mode_nginx && \
    ./configure --add-dynamic-module=modules/nginx_qatzip_module --add-dynamic-module=modules/nginx_qat_module --with-cc-opt="-DNGX_SECURE_MEM -I/opt/openssl/include -Wno-error=deprecated-declarations" --with-ld-opt="-L/opt/openssl/lib -L/opt/qat/lib -lqatzip -lz" --prefix=/var/www --sbin-path=/usr/local/sbin/nginx --modules-path=/usr/local/ifelse(index(DOCKER_IMAGE,ubuntu),-1,lib64,lib/x86_64-linux-gnu)/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/www/log/error.log --pid-path=/var/www/nginx.pid --lock-path=/var/www/nginx.lock --http-log-path=/var/www/log/access.log --http-client-body-temp-path=/var/www/tmp/client_body --http-proxy-temp-path=/var/www/tmp/proxy --http-fastcgi-temp-path=/var/www/tmp/fastcgi --http-uwsgi-temp-path=/var/www/tmp/uwsgi --http-scgi-temp-path=/var/www/tmp/scgi --user=ifelse(index(DOCKER_IMAGE,ubuntu),-1,nobody,www-data) --group=ifelse(index(DOCKER_IMAGE,ubuntu),-1,nobody,www-data) --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-pcre defn(`NGINX_HTTP_FLV_MODULE') && \
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

define(`INSTALL_PKGS_NGINX',ifelse(index(DOCKER_IMAGE,ubuntu),-1,openssl-libs pcre2 zlib libxslt ,libxml2 libssl1.0.0 libpcre3 zlib1g libxslt1.1 ))dnl
define(`INSTALL_NGINX',dnl
CMD /usr/local/sbin/nginx
VOLUME /etc/nginx /var/www/html /var/www/tmp/client_body /var/www/tmp/proxy /var/www/tmp/fastcgi /var/www/tmp/uwsgi /var/www/tmp/scgi /var/www/cache /var/www/dash /var/www/hls
EXPOSE 80
EXPOSE 443
)dnl
