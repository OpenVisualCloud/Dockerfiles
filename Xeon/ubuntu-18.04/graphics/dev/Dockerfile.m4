
FROM ubuntu:18.04 AS build
WORKDIR /home
define(`BUILD_LINKAGE',shared)dnl

include(build-tools.m4)
include(ispc.m4)
include(embree.m4)
include(OpenImageIO.m4)
include(ospray.m4)
include(ospray-mpi.m4)
#include(ospray-example_san-miguel.m4)
#include(ospray-example_xfrog.m4)

FROM build
LABEL Description="This is the image for graphics development on  Ubuntu 18.04 LTS"
LABEL Vendor="Intel Corporation"
WORKDIR /home
