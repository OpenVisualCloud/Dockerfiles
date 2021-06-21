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

DECLARE(`QAT_ZIP_VER',v1.0.4)

include(qat-core.m4)

ifelse(OS_NAME,ubuntu,`
define(`QAT_ZIP_BUILD_DEPS',`wget ca-certificates make gcc libzip-dev')
define(`QAT_ZIP_INSTALL_DEPS',`libzip`'ifelse(OS_VERSION,18.04,4,5)')
')

ifelse(OS_NAME,centos,`
define(`QAT_ZIP_BUILD_DEPS',`wget make gcc zlib-devel')
define(`QAT_ZIP_INSTALL_DEPS',`zlib')
')

define(`BUILD_QAT_ZIP',`
# load qat-zip
ARG QAT_ZIP_REPO=https://github.com/intel/QATzip/archive/QAT_ZIP_VER.tar.gz
RUN cd BUILD_HOME && \
    wget -O - ${QAT_ZIP_REPO} | tar xz && \
    cd QATzip* && \
    /bin/bash ./configure LDFLAGS="-Wl,-rpath=/opt/intel/QAT/build" --with-ICP_ROOT=/opt/intel/QAT --prefix=/opt/intel/QATzip && \
    make -j8 && \
    make install && \
    tar cf - /opt/intel/QATzip | (cd BUILD_DESTDIR && tar xf -)
')

define(`CLEANUP_QAT_ZIP',`dnl
ifelse(CLEANUP_DOC,yes,`dnl
RUN rm -rf /opt/intel/QATzip/share/man
')dnl
')

REG(QAT_ZIP)

include(end.m4)dnl
