# Build nginx-http-flv
ARG NGINX_HTTP_FLV_VER=04dc8369b260c8c851f12fc30ea2f9df03f73c4e
ARG NGINX_HTTP_FLV_REPO=https://github.com/winshining/nginx-http-flv-module.git
ARG NGINX_HTTP_FLV_PATCH_HLS=https://raw.githubusercontent.com/VCDP/CDN/master/0001-Add-SVT-HEVC-support-for-RTMP-and-HLS-on-Nginx-HTTP-FLV.patch
ARG NGINX_HTTP_FLV_PATCH_DASH=https://raw.githubusercontent.com/VCDP/CDN/master/0001-Add-SVT-HEVC-support-for-DASH-on-Nginx-HTTP-FLV.patch

define(`NGINX_HTTP_FLV_MODULE',--add-module=../nginx-http-flv-module )dnl
RUN git clone ${NGINX_HTTP_FLV_REPO} && \
    cd nginx-http-flv-module && \
    git checkout ${NGINX_HTTP_FLV_VER} && \
    mkdir -p /home/build/var/www/html && \
    cp -f stat.xsl /home/build/var/www/html && \
    wget -O - ${NGINX_HTTP_FLV_PATCH_HLS} | patch -p1 && \
    wget -O - ${NGINX_HTTP_FLV_PATCH_DASH} | patch -p1;
