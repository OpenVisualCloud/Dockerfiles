
FROM centos:7.6.1810 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libaom.m4)
include(cleanup.m4)dnl

FROM openvisualcloud/xeon-centos76-media-ffmpeg:latest
LABEL Description="This is the showcase image for SVT only features on CentOS 7.6"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
