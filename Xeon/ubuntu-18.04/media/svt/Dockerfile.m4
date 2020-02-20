
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libaom.m4)
include(cleanup.m4)dnl

FROM openvisualcloud/xeon-ubuntu1804-media-ffmpeg:latest
LABEL Description="This is the showcase image for SVT Ubuntu 18.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
