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

define(`NGINX_CERT_BUILD_DEPS',`openssl')

define(`BUILD_NGINX_CERT',`
# Generate a self-certificate for testing purpose
RUN mkdir -p BUILD_DESTDIR/etc/nginx && \
    printf "US\nOR\nPortland\nOregon\nData Center Group\nIntel Corporation\n%s\nnobody@intel.com\n" "$(hostname)" | openssl req -x509 -nodes -days 30 -newkey rsa:4096 -keyout BUILD_DESTDIR/etc/nginx/cert.key -out BUILD_DESTDIR/etc/nginx/cert.crt && \
    chmod 640 BUILD_DESTDIR/etc/nginx/cert.key && \
    chmod 644 BUILD_DESTDIR/etc/nginx/cert.crt
')

REG(NGINX_CERT)

include(end.m4)dnl
