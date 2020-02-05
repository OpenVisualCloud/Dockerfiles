
FROM centos:7.6.1810 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl
define(`BUILD_TOOLS_NO_ASM')dnl

include(build-tools.m4)
include(nginx-http-flv.m4)
include(nginx-upload.m4)
include(qat-driver.m4)
include(qat-openssl.m4)
include(qat-engine.m4)
include(qat-zip.m4)
include(nginx-qat.m4)
include(nginx-cert.m4)

FROM openvisualcloud/xeon-centos76-media-ffmpeg:latest
LABEL Description="This is the base image for the NGINX-QAT service"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)
# Install
include(install.m4)
