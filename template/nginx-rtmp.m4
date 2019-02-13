# Build nginx-rtmp
ARG NGINX_RTMP_VER=v1.2.1
ARG NGINX_RTMP_REPO=https://github.com/arut/nginx-rtmp-module/archive/${NGINX_RTMP_VER}.tar.gz
ARG NGINX_RTMP_PATCH_REPO=https://raw.githubusercontent.com/VCDP/CDN/master/Add-hevc-support-for-rtmp-dash-and-hls.patch

define(`NGINX_RTMP_MODULE',--add-module=../nginx-rtmp-module )dnl
RUN wget -O - ${NGINX_RTMP_REPO} | tar xz && mv nginx-rtmp-module-${NGINX_RTMP_VER#v} nginx-rtmp-module; \
    cd nginx-rtmp-module; \
    mkdir -p /home/build/var/www/html; \
    cp -f stat.xsl /home/build/var/www/html;
#    wget -O - ${NGINX_RTMP_PATCH_REPO} | patch -p1;

