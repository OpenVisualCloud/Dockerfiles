# Build nginx-http-flv
ARG NGINX_HTTP_FLV_VER=v1.2.7
ARG NGINX_HTTP_FLV_REPO=https://github.com/winshining/nginx-http-flv-module.git

ARG NGINX_HTTP_FLV_PATCHES_RELEASE_VER=0.2
ARG NGINX_HTTP_FLV_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}.tar.gz
ARG NGINX_HTTP_FLV_PATCHES_PATH=/home/CDN-${NGINX_HTTP_FLV_PATCHES_RELEASE_VER}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${NGINX_HTTP_FLV_PATCHES_RELEASE_URL} | tar xz

define(`NGINX_HTTP_FLV_MODULE',--add-module=../nginx-http-flv-module )dnl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN git clone ${NGINX_HTTP_FLV_REPO} && \
    cd nginx-http-flv-module && \
    git checkout ${NGINX_HTTP_FLV_VER} && \
    mkdir -p /home/build/var/www/html && \
    cp -f stat.xsl /home/build/var/www/html && \
    find ${NGINX_HTTP_FLV_PATCHES_PATH}/Nginx-HTTP-FLV_patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;
