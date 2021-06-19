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

DECLARE(`NGINX_FLV_VER',1.2.9)
DECLARE(`NGINX_FLV_PATCHES_VER',0.2)

ifelse(OS_NAME,ubuntu,`
define(`NGINX_FLV_BUILD_DEPS',`ca-certificates wget patch')
')

ifelse(OS_NAME,centos,`
define(`NGINX_FLV_BUILD_DEPS',`wget patch')
')

define(`BUILD_NGINX_FLV',`
ARG NGINX_FLV_PATCHES_REPO=https://github.com/VCDP/CDN/archive/`v'NGINX_FLV_PATCHES_VER.tar.gz
ARG NGINX_FLV_PATCHES_PATH=BUILD_HOME/CDN-NGINX_FLV_PATCHES_VER
RUN cd BUILD_HOME && \
    wget -O - ${NGINX_FLV_PATCHES_REPO} | tar xz

# build nginx flv
ARG NGINX_FLV_REPO=https://github.com/winshining/nginx-http-flv-module/archive/`v'NGINX_FLV_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${NGINX_FLV_REPO} | tar xz && \
    cd nginx-http-flv-module-NGINX_FLV_VER && \
    mkdir -p BUILD_DEST/var/www/html && \
    cp -f stat.xsl BUILD_DEST/var/www/html && \
    find ${NGINX_FLV_PATCHES_PATH}/Nginx-HTTP-FLV_patches -type f -name *.patch -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i
')

REG(NGINX_FLV)

include(end.m4)dnl
