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

DECLARE(`OWT_360',false)
DECLARE(`OWT_BRANCH', master)
DECLARE(`OWT_VER',v5.0)
DECLARE(`OWT_LICODE_VER',8b4692c88f1fc24dedad66b4f40b1f3d804b50ca)
DECLARE(`OWT_WEBRTC_BRANCH',59-server)
DECLARE(`OWT_WEBRTC_VER',)
DECLARE(`OWT_SDK_BRANCH',master)
DECLARE(`OWT_SDK_VER',v5.0)
DECLARE(`OWT_QUIC_VER',v0.1)
DECLARE(`LIBNICE_PATCH_VER',5.0)

# required components for OWT
include(openssl.m4)
define(`OPENH264_VER',v1.7.4)
include(openh264.m4)
define(`LIBRE_VER',v0.5.0)
include(libre.m4)
define(`LIBNICE_VER',0.1.4)
include(libnice.m4)
define(`USRSCTP_VER',0.9.5.0)
include(usrsctp.m4)
define(`JSONHPP_VER',v3.6.1)
include(jsonhpp.m4)
define(`NODE_INSTALL',true)
include(node.m4)
ifelse(OS_NAME,centos,`
define(`LIBSRTP2_VER',v2.1.0)
include(libsrtp2.m4)
')
define(`FFMPEG_ENABLE_LIBASS',true)
define(`FFMPEG_ENABLE_LIBFREETYPE',false)
define(`FFMPEG_ENABLE_V4L2',false)
define(`FFMPEG_ENABLE_X265',false)
define(`FFMPEG_ENABLE_X264',true)
include(ffmpeg.m4)

ifelse(OS_NAME,ubuntu,`
define(`OWT_BUILD_DEPS',`ifdef(`BUILD_OPENSSL',,libssl-dev ) git gcc npm python libglib2.0-dev libboost-thread-dev libboost-system-dev liblog4cxx-dev libsrtp2-dev pkg-config')
')

ifelse(OS_NAME,centos,`
define(`OWT_BUILD_DEPS',`ifdef(`BUILD_OPENSSL',,openssl-devel ) git gcc npm python glib2-devel boost-devel log4cxx-devel pkg-config ifelse(OS_VERSION,7,devtoolset-9)')
')

define(`BUILD_OWT',`
# Install npm modules
RUN npm install -g --loglevel error node-gyp@6.1.0 grunt-cli underscore jsdoc

# Get owt-server Source
ARG OWT_REPO=https://github.com/open-webrtc-toolkit/owt-server
RUN cd BUILD_HOME && \
    git clone -b OWT_BRANCH ${OWT_REPO} && \
    cd owt-server && \
    git reset --hard OWT_VER

# Prep OpenH264
RUN mkdir -p BUILD_HOME/owt-server/third_party/openh264 && \
    cd BUILD_HOME/owt-server/third_party/openh264 && \
    ln -s -v BUILD_PREFIX/include/openh264/codec . && \
    ln -s -v BUILD_LIBDIR/libopenh264.so . && \
    echo "const char* stub() {return \"this is a stub lib\";}" > pseudo-openh264.cpp && \
    gcc pseudo-openh264.cpp -fPIC -shared -o pseudo-openh264.so

# Get licode
ARG OWT_LICODE_REPO=https://github.com/lynckia/licode.git
RUN cd BUILD_HOME/owt-server/third_party && \
    git clone ${OWT_LICODE_REPO} && \
    cd licode && \
    git config user.name x && git config user.email x@y && \
    git reset --hard OWT_LICODE_VER && \
    git am BUILD_HOME/owt-server/scripts/patches/licode/*.patch

# Get webrtc
ARG OWT_WEBRTC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-webrtc.git
RUN mkdir -p BUILD_HOME/owt-server/third_party/webrtc && \
    cd BUILD_HOME/owt-server/third_party/webrtc && \
    git clone -b OWT_WEBRTC_BRANCH ${OWT_WEBRTC_REPO} src && \
    cd src && ifelse(OWT_360,true,`git reset --hard OWT_WEBRTC_VER &&')\
    ./tools-woogeen/install.sh && ifelse(OWT_360,true,`patch -p1 < BUILD_HOME/owt-server/scripts/patches/0001-Implement-RtcpFOVObserver.patch &&')\
    ./tools-woogeen/build.sh

ifelse(OWT_360, false, `
# Get webrtc79
RUN mkdir -p BUILD_HOME/owt-server/third_party/webrtc-m79 && \
    cd BUILD_HOME/owt-server/third_party/webrtc-m79 && \
    sed -i "s/git clone/git clone --depth 1/" ../../scripts/installWebrtc.sh && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable && ')bash ../../scripts/installWebrtc.sh`'ifelse(OS_NAME:OS_VERSION,centos:7,`)')
')

# Get SDK
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git
RUN cd BUILD_HOME && \
    git clone -b OWT_SDK_BRANCH ${OWT_SDK_REPO} && \
    cd owt-client-javascript/scripts && \
    git reset --hard OWT_SDK_VER && \
    npm install && grunt 
    
# Get quic
ARG OWT_QUIC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-quic/releases/download/OWT_QUIC_VER/dist.tgz
RUN mkdir -p BUILD_HOME/owt-server/third_party/quic-lib && \
    cd BUILD_HOME/owt-server/third_party/quic-lib && \
    wget -O - ${OWT_QUIC_REPO} | tar xz

# Build and pack owt
RUN cd BUILD_HOME/owt-server && \
ifdef(`BUILD_OPENSSL',`dnl
    sed -i "/cflags_cc/s/\[/[\"-Wl`,'rpath=patsubst(BUILD_PREFIX,`/',`\\/')\/ssl\/lib\"`,'/" ifelse(OWT_360,true, `source/agent/webrtc/webrtcLib/binding.gyp',`source/agent/webrtc/rtcConn/binding.gyp source/agent/webrtc/rtcFrame/binding.gyp') && \
    sed -i "s/-lssl/<!@(pkg-config --libs openssl)/" ifelse(OWT_360,true, `source/agent/webrtc/webrtcLib/binding.gyp',`source/agent/webrtc/rtcConn/binding.gyp source/agent/webrtc/rtcFrame/binding.gyp') && \
')dnl
    sed -i "/DENABLE_SVT_HEVC_ENCODER/i\"<!@(pkg-config --cflags SvtHevcEnc)\"`,'" source/agent/video/videoMixer/videoMixer_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoTranscoder_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoAnalyzer_sw/binding.sw.gyp && \
    sed -i "/lSvtHevcEnc/i\"<!@(pkg-config --libs SvtHevcEnc)\"`,'" source/agent/video/videoMixer/videoMixer_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoTranscoder_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoAnalyzer_sw/binding.sw.gyp && \
ifdef(`BUILD_GSTCORE',`dnl
    sed -i "s/--cflags glib-2.0/--cflags glib-2.0 gstreamer-1.0/" source/agent/analytics/videoGstPipeline/binding.pipeline.gyp && \
    sed -i "/lgstreamer/i\"<!@(pkg-config --libs gstreamer-1.0)\"`,'" source/agent/analytics/videoGstPipeline/binding.pipeline.gyp && \
')dnl
    sed -i "1i#include <stdint.h>" source/agent/sip/sipIn/sip_gateway/sipua/src/account.c

# Install nan module
RUN cd BUILD_HOME/owt-server && \
    echo {} > package.json && \
    npm install nan

# Build and package
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:BUILD_LIBDIR:/usr/local/ssl/lib
RUN cd BUILD_HOME/owt-server && \
    ifelse(OS_NAME:OS_VERSION,centos:7,`(. /opt/rh/devtoolset-9/enable &&')./scripts/build.js -t mcu-all -r -c`'ifelse(OS_NAME:OS_VERSION,centos:7,`) ') &&\
    ./scripts/pack.js -t all --install-module --no-pseudo ifelse(OWT_360,true,--sample-path, --app-path) BUILD_HOME/owt-client-javascript/dist/samples/conference && \
    mkdir -p BUILD_DESTDIR/home && \
    mv dist BUILD_DESTDIR/home/owt

 RUN cd BUILD_DESTDIR/home && \
    echo "#!/bin/bash -e" >>launch.sh && \
    echo ifelse(OS_NAME,centos,`"mongod --config /etc/mongod.conf &" ',`"service mongodb start &" ')>>launch.sh && \
    echo ifelse(OS_NAME,centos,`"rabbitmq-server &" ',`"service rabbitmq-server start &" ')>>launch.sh && \
    echo "while ! mongo --quiet --eval \"db.adminCommand(\\\"listDatabases\\\")\"" >>launch.sh && \
    echo "do" >>launch.sh && \
    echo "  echo mongod not launch" >>launch.sh && \
    echo "  sleep 1" >>launch.sh && \
    echo "done" >>launch.sh && \
    echo "echo mongodb connected successfully" >>launch.sh && \
    echo "cd /home/owt" >>launch.sh && \
    echo "./management_api/init.sh" >>launch.sh && \
    echo "./bin/start-all.sh" >>launch.sh && \
    chmod +x launch.sh
')

ifelse(OS_NAME,ubuntu,`
define(`OWT_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,libssl1.1) rabbitmq-server mongodb ifelse(OS_VERSION,18.04,libboost-system1.65.1,libboost-system1.71.0) ifelse(OS_VERSION,18.04,libboost-thread1.65.1,libboost-thread1.71.0) liblog4cxx10v5 libglib2.0-ifelse($1,devel,dev,0) libfreetype6 libsrtp2-1')
')

ifelse(OS_NAME,centos,`
define(`OWT_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,openssl11) rabbitmq-server boost-system boost-thread log4cxx ifelse($1,devel,glib2-devel,glib2) freetype')

define(`INSTALL_OWT',`
# install OWT
RUN echo "[mongodb-org-3.6]" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" >> /etc/yum.repos.d/mongodb-org-3.6.repo && \
    yum install -y -q mongodb-org && rm -rf /var/cache/yum/*
')

')

define(`CLEANUP_OWT',`dnl
ifelse(CLEANUP_CC,yes,`dnl
RUN rm -rf BUILD_DESTDIR/home/owt/analytics_agent/plugins
')')

REG(OWT)

include(end.m4)dnl
