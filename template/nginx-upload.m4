# Build nginx-upload-module
ARG NGINX_UPLOAD_VER=2.3.0
ARG NGINX_UPLOAD_REPO=https://github.com/fdintino/nginx-upload-module/archive/${NGINX_UPLOAD_VER}.tar.gz

define(`NGINX_UPLOAD_MODULE',--add-module=../nginx-upload-module-${NGINX_UPLOAD_VER} )dnl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - ${NGINX_UPLOAD_REPO} | tar xz
