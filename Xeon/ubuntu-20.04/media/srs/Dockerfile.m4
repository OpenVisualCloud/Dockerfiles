
include(begin.m4)
include(ubuntu.m4)
include(openssl.m4)
include(srs.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-ubuntu2004-media-ffmpeg:latest
LABEL Description="This is the base image for Media SRS OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
UPGRADE_UBUNTU_COMPONENTS()
INSTALL_ALL(runtime,build)

