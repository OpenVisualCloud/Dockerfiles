
FROM centos:7.4.1708 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libogg.m4)
include(libvorbis.m4)
include(libmp3lame.m4)
include(libfdk-aac.m4)
include(libopus.m4)
include(libvpx.m4)
include(libaom.m4)
include(libx264.m4)
include(libx265.m4)
include(svt-hevc.m4)
#include(transform360.m4)
include(gmmlib.m4)
include(libdrm.m4)
include(libva.m4)
include(media-driver.m4)
include(media-sdk.m4)
include(dldt-ie.m4)
include(gst.m4)
include(gst-plugin-base.m4)
include(gst-plugin-good.m4)
include(gst-plugin-bad.m4)
include(gst-plugin-ugly.m4)
include(gst-plugin-libav.m4)
include(automake.m4)
include(gst-plugin-vaapi.m4)
include(ffmpeg.m4)
include(cleanup.m4)dnl

FROM centos:7.4.1708
LABEL Description="This is the image for FFMPEG and GSTREAMER application development on CentOS 7.4"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
