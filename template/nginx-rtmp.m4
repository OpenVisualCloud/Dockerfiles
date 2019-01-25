# Build nginx-rtmp
ARG NGINX_RTMP_VER=v1.2.1
ARG NGINX_RTMP_REPO=https://github.com/arut/nginx-rtmp-module/archive/${NGINX_RTMP_VER}.tar.gz
ARG NGINX_RTMP_PATCH_REPO=https://raw.githubusercontent.com/VCDP/CDN/master/Add-hevc-support-for-rtmp-dash-and-hls.patch
ARG NGINX_RTMP_STAT_REPO=https://raw.githubusercontent.com/arut/nginx-rtmp-module/${NGINX_RTMP_VER}/stat.xsl

define(`NGINX_RTMP_MODULE',--add-module=../nginx-rtmp-module )dnl
RUN wget -O - ${NGINX_RTMP_REPO} | tar xz && mv nginx-rtmp-module-${NGINX_RTMP_VER#v} nginx-rtmp-module
#    cd nginx-rtmp-module;
#    wget -O - ${NGINX_RTMP_PATCH_REPO} | patch -p1;

RUN mkdir -p /home/build/var/www/html; \
    wget -O /home/build/var/www/html/stat.xsl ${NGINX_RTMP_STAT_REPO};

