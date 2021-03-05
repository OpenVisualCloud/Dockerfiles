
include(begin.m4)
include(ubuntu.m4)
include(nginx-flv.m4)
include(nginx-upload.m4)
include(nginx.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeone3-OS_NAME`'patsubst(OS_VERSION,\.)-media-ffmpeg:BUILD_VERSION
LABEL Description="This is the base image for NGINX+RTMP OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)

