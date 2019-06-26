
FROM centos:7.4.1708 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl
define(`BUILD_TOOLS_NO_ASM')dnl

include(build-tools.m4)
include(nginx-rtmp.m4)
include(nginx-upload.m4)
include(nginx.m4)dnl

FROM openvisualcloud/vca2-centos74-media-ffmpeg:latest
LABEL Description="This is the base image for a NGINX service"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)
# Install
include(install.m4)
