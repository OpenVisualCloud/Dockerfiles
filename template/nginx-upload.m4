# Build NGINX Upload Mode

ARG  NGINX_UPLOAD_MODULE_VER=2.3.0
ARG  NGINX_UPLOAD_MODULE_REPO=https://github.com/fdintino/nginx-upload-module/archive/${NGINX_UPLOAD_MODULE_VER}.tar.gz
ARG  OPENSSL_VER=1_0_2s
ARG  OPENSSL_REPO=https://github.com/openssl/openssl/archive/OpenSSL_${OPENSSL_VER}.tar.gz
ARG  PCRE_VER=8.43
ARG  PCRE_REPO=https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VER}.tar.gz
ARG  ZLIB_VER=1.2.11
ARG  ZLIB_REPO=https://zlib.net/fossils/zlib-${ZLIB_VER}.tar.gz

define(`NGINX_UPLOAD_MODULE',--add-module=../nginx-upload-module-${NGINX_UPLOAD_MODULE_VER} )dnl
RUN wget -O - ${NGINX_UPLOAD_MODULE_REPO} | tar xz && \
    wget -O - ${OPENSSL_REPO} | tar xz && \
    wget -O - ${PCRE_REPO} | tar xz && \
    wget -O - ${ZLIB_REPO} | tar xz 


