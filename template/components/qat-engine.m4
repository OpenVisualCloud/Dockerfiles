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

DECLARE(`QAT_ENGINE_VER',v0.6.4)
dnl CentOS QAT 1.7.0-470b06 only supports QAT engine version up to 0.5.43.
dnl CentOS QAT 1.7.0-470b12 and above can support QAT engine version beyond 0.5.43.

include(openssl.m4)

ifelse(OS_NAME,ubuntu,`
define(`QAT_ENGINE_BUILD_DEPS',`wget ca-certificates make gcc gawk autoconf automake libtool pkg-config')
')

ifelse(OS_NAME,centos,`
define(`QAT_ENGINE_BUILD_DEPS',`wget make gcc gawk autoconf automake libtool pkg-config')
')

define(`BUILD_QAT_ENGINE',`
# load qat-engine
ARG QAT_ENGINE_REPO=https://github.com/intel/QAT_Engine/archive/QAT_ENGINE_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${QAT_ENGINE_REPO} | tar xz && \
    cd QAT_Engine* && \
    ./autogen.sh && \
    export PERL5LIB="$(ls -1 -d BUILD_HOME/openssl-*)" && \
    ./configure --with-qat_dir=/opt/intel/QAT --with-openssl_dir="$PERL5LIB" --with-openssl_install_dir=BUILD_PREFIX/ssl --prefix=/opt/intel/QATengine --disable-qat_ecx --with-cc-opt="-DQAT_DISABLE_NONZERO_MEMFREE" ifdef(`BUILD_QAT_CRYPTOMB',--enable-multibuff_offload --enable-multibuff_ecx) && \
    make -j8 && \
    make install && \
    tar cf - BUILD_PREFIX/ssl | (cd BUILD_DESTDIR && tar xf -)
')

define(`QAT_ENGINE_ENV_VARS',`dnl
ENV OPENSSL_ENGINES=BUILD_PREFIX/ssl/lib/engines-1.1
')

define(`INSTALL_QAT_ENGINE',`dnl
RUN echo "/opt/intel/QAT/build" >> /etc/ld.so.conf.d/qat.conf && ldconfig
')

REG(QAT_ENGINE)

include(end.m4)dnl
