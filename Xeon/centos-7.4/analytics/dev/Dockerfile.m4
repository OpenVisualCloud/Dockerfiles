
FROM centos:7.4.1708 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`BUILD_MP3LAME'),`ON',`include(libmp3lame.m4)')
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(libopus.m4)
include(libvpx.m4)
include(libaom.m4)
include(libx264.m4)
include(libx265.m4)
include(dav1d.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
include(svt-vp9.m4)
include(libjsonc.m4)
include(librdkafka.m4)
include(gst.m4)
include(gst-orc.m4)
include(gst-plugin-base.m4)
include(gst-plugin-good.m4)
include(gst-plugin-bad.m4)
include(gst-plugin-ugly.m4)
include(gst-plugin-libav.m4)
include(gst-plugin-svt.m4)
include(opencv.m4)
include(dldt-ie.m4)
include(gst-plugin-gva.m4)
include(ffmpeg.m4)
OPENCV_REMAKE_VIDEOIO()
include(cleanup.m4)dnl

FROM centos:7.4.1708
LABEL Description="This is the image for FFMPEG and GSTREAMER application for analytics development on CentOS 7.4"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
