
FROM centos:7.5.1804 AS build
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
include(gmmlib.m4)
include(libva.m4)
include(libva-utils.m4)
include(media-driver.m4)
include(media-sdk.m4)
include(opencl.m4)
include(gst.m4)
include(gst-orc.m4)
include(gst-plugin-base.m4)
include(gst-plugin-good.m4)
include(gst-plugin-bad.m4)
include(gst-plugin-ugly.m4)
include(gst-plugin-libav.m4)
include(gst-plugin-vaapi.m4)
include(opencv.m4)
include(openvino.binary.m4)
include(gstreamer-videoanalytics.m4)
include(cleanup.m4)dnl

FROM centos:7.5.1804
LABEL Description="This is the image for DLDT and GST on CentOS 7.6."
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
