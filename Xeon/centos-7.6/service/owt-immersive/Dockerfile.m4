
FROM centos:7.6.1810 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

ifelse(index(DOCKER_IMAGE,ubuntu),-1,
RUN yum install -y -q patch centos-release-scl && \
    yum install -y -q devtoolset-7 && \
    source /opt/rh/devtoolset-7/enable
)
include(build-tools.m4)
include(openssl.m4)
include(libre.m4)
include(usrsctp.m4)
include(libsrtp2.m4)
ifelse(defn(`BUILD_FDKAAC'),`ON',`include(libfdk-aac.m4)')
include(ffmpeg.m4)
include(nodetools.m4)
include(svt-hevc.1-4-3.m4)
include(owt-immersive.m4)dnl

FROM centos:7.6.1810
LABEL Description="This is the image for owt development on CentOS 7.6"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Prerequisites
include(nodetools.m4)
include(install.pkgs.owt.m4)

