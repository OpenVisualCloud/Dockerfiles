
FROM ubuntu:16.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl
define(`BUILD_TOOLS_NO_ASM')dnl

include(build-tools.m4)
include(nginx-rtmp.m4)
include(nginx.m4)dnl

FROM openvisualcloud/xeone3-ubuntu1604-media-ffmpeg:latest
LABEL Description="This is the base image for a NGINX+RTMP service"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)
# Install
include(install.m4)
