
include(begin.m4)
include(ubuntu.m4)
include(libnice.m4)
include(openssl.m4)
include(usrsctp.m4)
define(`NODE_INSTALL',true)
include(node.m4)
include(jsonhpp.m4)
include(libre050.m4)
include(owt.m4)
include(end.m4)dnl

PREAMBLE
FROM openvisualcloud/xeon-defn(`OS_NAME')patsubst(OS_VERSION,\.)-media-ffmpeg:build as build

BUILD_ALL()dnl
CLEANUP()dnl

FROM openvisualcloud/xeon-defn(`OS_NAME')patsubst(OS_VERSION,\.)-media-ffmpeg:latest
LABEL Description="This is the base image for the OWT service OS_NAME OS_VERSION"
LABEL Vendor="Intel Corporation"
WORKDIR /home

# Install
INSTALL_ALL(runtime,build)

