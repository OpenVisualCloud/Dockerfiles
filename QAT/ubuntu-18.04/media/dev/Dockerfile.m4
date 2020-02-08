
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl
define(`BUILD_TOOLS_NO_ASM')dnl

include(build-tools.m4)
include(nginx-http-flv.m4)
include(nginx-upload.m4)
include(qat.m4)
include(qat-zip.m4)
include(qat-openssl.m4)
include(qat-engine.m4)
include(nginx-qat.m4)
include(nginx-cert.m4)
include(cleanup.m4)

FROM openvisualcloud/xeon-ubuntu1804-media-dev:latest
LABEL Description="This is the media development image"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)
# Install
include(install.m4)

