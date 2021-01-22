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

DECLARE(`SRS_VER',v4.0.62)
DECLARE(`SRS_ENABLE_HDS',on)

ifelse(OS_NAME,ubuntu,`
define(`SRS_BUILD_DEPS',`git ca-certificates g++ make unzip patch pkg-config ifdef(BUILD_OPENSSL,,libssl-dev )')
')

ifelse(OS_NAME,centos,`
define(`SRS_BUILD_DEPS',`git gcc-c++ make unzip patch pkg-config ifdef(BUILD_OPENSSL,,libssl-devel )')
')

define(`BUILD_SRS',`
ARG SRS_REPO=https://github.com/ossrs/srs.git
RUN cd BUILD_HOME && \
    git clone -b SRS_VER --depth 1 ${SRS_REPO} && \
    cd srs/trunk && \
    sed -i "s/^SrsLinkOptions=\"/SrsLinkOptions=\"\$\(pkg-config --libs openssl\) -Wl,-rpath=patsubst(defn(`BUILD_PREFIX'),/,\\/)\/ssl\/lib /" configure && \
    ./configure --prefix=BUILD_PREFIX/srs \
        --hds=defn(`SRS_ENABLE_HDS') \
        --ssl=on --https=on --sys-ssl=on \
        --stream-caster=on \
        --ffmpeg-fit=off \
        --research=off \
        --cherrypy=off \
        --utest=off \
        --nasm=ifdef(BUILD_NASM,on,off) \
        --srt=ifdef(BUILD_LIBSRT,on,off) \
        --rtc=on \
        --gb28181=on \
        --extra-flags=$(pkg-config --cflags openssl) \
        --jobs=$(nproc) && \
    make -j$(nproc) && touch research/api-server/static-dir/crossdomain.xml && \
    make install DESTDIR=BUILD_DESTDIR

RUN echo BUILD_DESTDIR
RUN ls BUILD_DESTDIR
')

ifelse(OS_NAME,ubuntu,`
define(`SRS_INSTALL_DEPS',`bash ifdef(`BUILD_OPENSSL',,openssl)')
')

ifelse(OS_NAME,centos,`
define(`SRS_INSTALL_DEPS',`bash ifdef(`BUILD_OPENSSL',,openssl)')
')

REG(SRS)

include(end.m4)dnl
