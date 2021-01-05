divert(-1)

include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libx264.m4)
include(libx265.m4)
#include(dav1d.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
#include(svt-vp9.m4)
include(ffmpeg.m4)
divert(0)
PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for FFMPEG Ubuntu 20.04"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)

