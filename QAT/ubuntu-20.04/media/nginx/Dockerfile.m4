
include(begin.m4)
include(nasm.m4)
include(qat-core.m4)
include(qat-zip.m4)
include(openssl.m4)
include(qat-cryptomb.m4)
#include(ipsecmb.m4)
include(qat-engine.m4)
include(nginx-flv.m4)
include(nginx-upload.m4)
include(qat-nginx.m4)
include(nginx-cert.m4)
include(end.m4)

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-OS_NAME`'patsubst(OS_VERSION,\.)-media-ffmpeg:BUILD_VERSION
LABEL Description="This is the base image for QAT NGINX OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)
