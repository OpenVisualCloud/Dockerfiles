
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libogg.m4)
include(libvorbis.m4)
ifelse(defn(`SECURITY_STRICT'),`No',`include(libmp3lame.m4)')
include(libfdk-aac.m4)
include(libopus.m4)
include(libvpx.m4)
include(libaom.m4)
include(libx264.m4)
include(libx265.m4)
include(svt-hevc.m4)
include(svt-av1.m4)
include(svt-vp9.m4)
include(gmmlib.m4)
include(libdrm.m4)
include(libva.m4)
include(libva-utils.m4)
include(media-driver.m4)
include(media-sdk.m4)
include(opencl.m4)
include(dldt-ie.m4)
include(gst.m4)
include(gst-orc.m4)
include(gst-plugin-base.m4)
include(gst-plugin-good.m4)
include(gst-plugin-bad.m4)
include(gst-plugin-ugly.m4)
include(gst-plugin-libav.m4)
include(gst-plugin-svt.m4)
include(gst-plugin-vaapi.m4)
include(opencv.m4)
include(gstreamer-videoanalytics.m4)
include(cleanup.m4)dnl

FROM ubuntu:18.04
LABEL Description="This is the base image for GSTREAMER & DLDT Ubuntu 16.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(install.pkgs.m4)

# Install
include(install.m4)
