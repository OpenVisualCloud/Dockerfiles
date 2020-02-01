
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl
define(`BUILD_TOOLS_NO_ASM')dnl

include(build-tools.m4)
#include(qat-kernel.m4)
#include(qat-driver.m4)
#include(qat-engine.m4)
#include(qat-zip.m4)
include(qat-openssl.m4)
include(nginx-qat.m4)

#FROM openvisualcloud/xeon-ubuntu1804-media-ffmpeg:latest
#LABEL Description="This is the base image for a NGINX+RTMP service"
#LABEL Vendor="Intel Corporation"
#WORKDIR /home

# Prerequisites
#include(install.pkgs.m4)
# Install
#include(install.m4)
