
FROM ubuntu:16.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
include(svt-vp9.m4)
include(cleanup.m4)dnl

FROM ubuntu:16.04
LABEL Description="This is the showcase image for SVT Ubuntu 16.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
