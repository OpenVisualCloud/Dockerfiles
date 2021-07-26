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

DECLARE(`LIBPAHO_VER',1.3.9)

ifelse(OS_NAME,ubuntu,`
define(`LIBPAHO_BUILD_DEPS',`wget make libssl-dev uuid-dev')')

ifelse(OS_NAME,centos,`
define(`LIBPAHO_BUILD_DEPS',`wget make openssl-devel')')

define(`BUILD_LIBPAHO',`
# build libpahomqtt
ARG PAHO_VER=LIBPAHO_VER
ARG LIBPAHO_REPO=https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_VER}.tar.gz
RUN cd BUILD_HOME && \
  wget -O - ${LIBPAHO_REPO} | tar -xz
RUN cd BUILD_HOME/paho.mqtt.c-LIBPAHO_VER && \
  make	&& \
  make install

#Copy and link in runtime layer
RUN cd BUILD_HOME/paho.mqtt.c-LIBPAHO_VER && \
  cp build/output/libpaho-mqtt3c.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR && 	\
  cp build/output/libpaho-mqtt3cs.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR &&   \
  cp build/output/libpaho-mqtt3a.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR &&   \
  cp build/output/libpaho-mqtt3as.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR &&   \
  cp build/output/paho_c_version BUILD_DESTDIR/usr/local/bin/ && \
  cp build/output/samples/paho_c_pub BUILD_DESTDIR/usr/local/bin/ && \
  cp build/output/samples/paho_c_sub BUILD_DESTDIR/usr/local/bin/ && \
  cp build/output/samples/paho_cs_pub BUILD_DESTDIR/usr/local/bin/ && \
  cp build/output/samples/paho_cs_sub BUILD_DESTDIR/usr/local/bin/ && \
  chmod 644 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3c.so.1.3 && \
  chmod 644 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3cs.so.1.3 && \
  chmod 644 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3a.so.1.3 && \
  chmod 644 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3as.so.1.3 && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3c.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3c.so.1 && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3cs.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3cs.so.1 && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3a.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3a.so.1 && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3as.so.1.3 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3as.so.1 && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3c.so.1 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3c.so && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3cs.so.1 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3cs.so && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3a.so.1 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3a.so && \
  ln BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3as.so.1 BUILD_DESTDIR/BUILD_LIBDIR/libpaho-mqtt3as.so && \
  cp src/MQTTAsync.h BUILD_DESTDIR/usr/local/include/ && \
  cp src/MQTTClient.h BUILD_DESTDIR/usr/local/include/ && \
  cp src/MQTTClientPersistence.h BUILD_DESTDIR/usr/local/include/ && \
  cp src/MQTTProperties.h BUILD_DESTDIR/usr/local/include/ && \
  cp src/MQTTReasonCodes.h BUILD_DESTDIR/usr/local/include/ && \
  cp src/MQTTSubscribeOpts.h BUILD_DESTDIR/usr/local/include/; 
')dnl

REG(LIBPAHO)

include(end.m4)dnl
