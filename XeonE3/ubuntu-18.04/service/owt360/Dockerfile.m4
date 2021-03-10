

include(begin.m4)
include(cmake.m4)
include(openssl.m4)
include(svt-hevc.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libvpx.m4)
include(libx264.m4)
include(gmmlib.m4)
include(libva2.m4)
include(media-driver.m4)
include(msdk.m4)
include(opencv.m4)
include(dldt-ie.m4)
include(ffmpeg.m4)
include(scvp.m4)
include(owt360.m4)
include(end.m4)dnl

PREAMBLE
FROM OS_NAME:OS_VERSION AS build

BUILD_ALL()dnl
CLEANUP()dnl

FROM OS_NAME:OS_VERSION
LABEL Description="This is the base image for the OWT 360 service OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)

