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

DECLARE(`OWT_VER',)
DECLARE(`OWT_OPENH264_VER',v1.7.4)
DECLARE(`OWT_LICODE_VER',8b4692c88f1fc24dedad66b4f40b1f3d804b50ca)
DECLARE(`OWT_WEBRTC_VER',59-server)
DECLARE(`OWT_SDK_VER',master)
DECLARE(`OWT_QUIC_VER',v0.1)

ifelse(OS_NAME,ubuntu,`
define(`OWT_BUILD_DEPS',`ifdef(`BUILD_OPENSSL',,libssl-dev )git gcc npm python libglib2.0-dev libboost-thread-dev libboost-system-dev liblog4cxx-dev libsrtp2-dev bzip2 pkg-config libgstreamer-plugins-base1.0-dev')
')

ifelse(OS_NAME,centos,`
define(`OWT_BUILD_DEPS',`ifdef(`BUILD_OPENSSL',,openssl-devel )git gcc npm python bzip2')
')

define(`BUILD_OWT',`
# Install npm modules
RUN npm install -g --loglevel error node-gyp@6.1.0 grunt-cli underscore jsdoc

# Get owt-server Source
ARG OWT_REPO=https://github.com/open-webrtc-toolkit/owt-server
RUN cd BUILD_HOME && \
    git clone --depth 1 ${OWT_REPO}

# Get OpenH264
ARG OWT_OPENH264_SRC_REPO=https://github.com/cisco/openh264/archive/patsubst(OWT_OPENH264_VER,`.[0-9]*$',`.0').tar.gz
ARG OWT_OPENH264_BIN_REPO=https://github.com/cisco/openh264/releases/download/patsubst(OWT_OPENH264_VER,`.[0-9]*$',`.0')/libopenh264-patsubst(OWT_OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0')-linux64.regexp(OWT_OPENH264_VER,`\([0-9]*\)$',`\1').so.bz2
RUN mkdir -p BUILD_HOME/owt-server/third_party/openh264 && \
    cd BUILD_HOME/owt-server/third_party/openh264 && \
    wget -O - ${OWT_OPENH264_SRC_REPO} | tar xz openh264-patsubst(OWT_OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0')/codec/api && \
    ln -s -v openh264-patsubst(OWT_OPENH264_VER,`v\([0-9]*\.[0-9]*\)\..*$',`\1.0')/codec codec && \
    wget -O - ${OWT_OPENH264_BIN_REPO} | bunzip2 > libopenh264.so.regexp(OWT_OPENH264_VER,`\([0-9]*\)$',`\1') && \
    ln -s -v libopenh264.so.regexp(OWT_OPENH264_VER,`\([0-9]*\)$',`\1') libopenh264.so && \
    echo "const char* stub() {return \"this is a stub lib\";}" > pseudo-openh264.cpp && \
    gcc pseudo-openh264.cpp -fPIC -shared -o pseudo-openh264.so

# Get licode
ARG OWT_LICODE_REPO=https://github.com/lynckia/licode.git
RUN cd BUILD_HOME/owt-server/third_party && \
    git clone ${OWT_LICODE_REPO} && \
    cd licode && \
    git reset --hard OWT_LICODE_VER && \
    git am BUILD_HOME/owt-server/scripts/patches/licode/*.patch

# Get webrtc
ARG OWT_WEBRTC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-webrtc.git
RUN mkdir -p BUILD_HOME/owt-server/third_party/webrtc && \
    cd BUILD_HOME/owt-server/third_party/webrtc && \
    git clone -b OWT_WEBRTC_VER --depth 1 ${OWT_WEBRTC_REPO} src && \
    ./src/tools-woogeen/install.sh && \
    ./src/tools-woogeen/build.sh

# Get webrtc79
RUN mkdir -p BUILD_HOME/owt-server/third_party/webrtc-m79 && \
    cd BUILD_HOME/owt-server/third_party/webrtc-m79 && \
    sed -i "s/git clone/git clone --depth 1/" ../../scripts/installWebrtc.sh && \
    bash ../../scripts/installWebrtc.sh

# Get SDK
ARG OWT_SDK_REPO=https://github.com/open-webrtc-toolkit/owt-client-javascript.git
RUN cd BUILD_HOME && \
    git clone -b OWT_SDK_VER --depth 1 ${OWT_SDK_REPO} && \
    cd owt-client-javascript/scripts && \
    npm install && grunt 
    
# Get quic
ARG OWT_QUIC_REPO=https://github.com/open-webrtc-toolkit/owt-deps-quic/releases/download/OWT_QUIC_VER/dist.tgz
RUN mkdir -p BUILD_HOME/owt-server/third_party/quic-lib && \
    cd BUILD_HOME/owt-server/third_party/quic-lib && \
    wget -O - ${OWT_QUIC_REPO} | tar xz

# Build and pack owt
RUN cd BUILD_HOME/owt-server && \
ifdef(`BUILD_OPENSSL',`dnl
    sed -i "/cflags_cc/s/\[/[\"-Wl`,'rpath=patsubst(BUILD_PREFIX,`/',`\\/')\/ssl\/lib\"`,'/" source/agent/webrtc/rtcConn/binding.gyp source/agent/webrtc/rtcFrame/binding.gyp && \
    sed -i "s/-lssl/<!@(pkg-config --libs openssl)/" source/agent/webrtc/rtcConn/binding.gyp source/agent/webrtc/rtcFrame/binding.gyp && \
')dnl
    sed -i "/DENABLE_SVT_HEVC_ENCODER/i\"<!@(pkg-config --cflags SvtHevcEnc)\"`,'" source/agent/video/videoMixer/videoMixer_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoTranscoder_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoAnalyzer_sw/binding.sw.gyp && \
    sed -i "/lSvtHevcEnc/i\"<!@(pkg-config --libs SvtHevcEnc)\"`,'" source/agent/video/videoMixer/videoMixer_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoTranscoder_sw/binding.sw.gyp source/agent/video/videoTranscoder/videoAnalyzer_sw/binding.sw.gyp && \
    sed -i "1i#include<stdint.h>" source/agent/sip/sipIn/sip_gateway/sipua/src/account.c && \
    npm install nan && \
    ./scripts/build.js -t mcu-all -r -c && \
    ./scripts/pack.js -t all --install-module --no-pseudo --app-path BUILD_HOME/owt-client-javascript/dist/samples/conference
')

ifelse(OS_NAME,ubuntu,`
define(`OWT_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,libssl1.1 )rabbitmq-server mongodb libboost-system1.65.1 libboost-thread1.65.1 liblog4cxx10v5 libglib2.0-0 libfreetype6 libsrtp2')
')

ifelse(OS_NAME,centos,`
define(`OWT_INSTALL_DEPS',`ifdef(`BUILD_OPENSSL',,openssl )')
')

REG(OWT)

include(end.m4)dnl
