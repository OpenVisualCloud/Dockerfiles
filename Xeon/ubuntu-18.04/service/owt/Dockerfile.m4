
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(libnice014.m4)
include(openssl.m4)
include(libre.m4)
include(usrsctp.m4)
include(libsrtp2.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(ffmpeg-n4.1.m4)
include(nodetools.m4)
include(svt-hevc.1-3-0.m4)
include(owt.m4)dnl

FROM ubuntu:18.04 
LABEL Description="This is the image for owt development on Ubuntu 18.04"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(nodetools.m4)
include(install.pkgs.owt.m4)

